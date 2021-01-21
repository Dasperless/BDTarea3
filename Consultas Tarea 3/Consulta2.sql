USE [ProyectoBD1] --Colocar Nombre de la Base de Datos 
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE
	OR

ALTER PROCEDURE [dbo].[Consulta2] --Nombre del procedimiento
	@inNdias INT
	,--Variables de entrada del SP
	@OutListadoCuentasId INT OUTPUT
	,@OutResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	--Se declaran variables
	DECLARE @multasExcesoRetirosCA TABLE (
		id INT IDENTITY(1, 1)
		,Fecha DATE
		,Monto MONEY
		,NuevoSaldo MONEY
		,EstadoCuentaid INT
		,TipoMovimientoCuentaAhorroid INT --Tabla con todas las multas por exceso de retiros CA
		,CuentaAhorroid INT
		,Descripcion VARCHAR(100)
		)
	DECLARE @retirosCA TABLE (
		id INT IDENTITY(1, 1)
		,Fecha DATE
		,Monto MONEY
		,NuevoSaldo MONEY
		,EstadoCuentaid INT
		,TipoMovimientoCuentaAhorroid INT --Tabla con todos los retiros en ATM 
		,CuentaAhorroid INT
		,Descripcion VARCHAR(100)
		)
	DECLARE @Fecha DATE
		,@Monto MONEY
		,@NuevoSaldo MONEY
		,@EstadoCuentaid INT
		,@TipoMovimientoCuentaAhorroid INT
		,@CuentaAhorroid INT
		,@Descripcion VARCHAR(100)
	DECLARE @listadoCuentas TABLE (
		--Tabla con el listado de cuentas que nos pide la consulta 
		id INT IDENTITY(1, 1)
		,CuentaAhorroId INT
		,PromedioRetirosMes INT
		,FechaCantidadMayorRetiros VARCHAR(100)
		,FechaDeEjecucion DATE
		)
	DECLARE @varCuentaAhorroid INT
		,@VarPromedioRetirosMes FLOAT
		,@VarFechaCantidadMayorRetiros VARCHAR(100)
		,@varFechaDeEjecucion DATE
	DECLARE @lo INT
		,@hi INT --variables lógicas 
		,@lo2 INT
		,@hi2 INT
		,@FechaComision DATE
		,@FechaRetirosFin DATE
		,@ContadorRetiros INT
		,@Cuentaid INT
		,@Fecha1 DATE
		,@Fecha2 DATE
		,@FechaCasual DATE
		,@RetirosPorMesVAR INT
		,@RetirosPorMes INT

	SELECT @lo = MIN(id)
		,@hi = MAX(id)
	FROM dbo.MovimientoCuentaAhorro

	--Validaciones
	IF NOT EXISTS (
			SELECT 1
			FROM [dbo].MovimientoCuentaAhorro
			)
	BEGIN
		SET @OutResultCode = 50021 --Si no hay movimiento

		RETURN
	END;
	ELSE IF (@inNdias = 0)
	BEGIN
		SET @OutResultCode = 50022 --si n dias es 0

		RETURN
	END;

	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED

		BEGIN TRANSACTION transaccionListadoCuentas

		WHILE @lo <= @hi
		BEGIN
			SELECT @Fecha = mov.Fecha
				,@Monto = mov.Monto
				,@NuevoSaldo = mov.NuevoSaldo
				,@EstadoCuentaid = mov.EstadoCuentaid
				,@TipoMovimientoCuentaAhorroid = mov.TipoMovimientoCuentaAhorroid
				,@CuentaAhorroid = mov.CuentaAhorroid
				,@Descripcion = mov.Descripcion
			FROM dbo.MovimientoCuentaAhorro mov
			WHERE mov.id = @lo

			IF (@TipoMovimientoCuentaAhorroid = 9) --9 es el movimiento por multa en CA
			BEGIN
				INSERT INTO @multasExcesoRetirosCA (
					Fecha
					,Monto
					,NuevoSaldo
					,EstadoCuentaid
					,TipoMovimientoCuentaAhorroid
					,CuentaAhorroid
					,Descripcion
					)
				VALUES (
					@Fecha
					,@Monto
					,@NuevoSaldo
					,@EstadoCuentaid
					,@TipoMovimientoCuentaAhorroid
					,@CuentaAhorroid
					,@Descripcion
					)
			END;
			ELSE IF (@TipoMovimientoCuentaAhorroid = 2) --2 es un retiro en ATM 
			BEGIN
				INSERT INTO @retirosCA (
					Fecha
					,Monto
					,NuevoSaldo
					,EstadoCuentaid
					,TipoMovimientoCuentaAhorroid
					,CuentaAhorroid
					,Descripcion
					)
				VALUES (
					@Fecha
					,@Monto
					,@NuevoSaldo
					,@EstadoCuentaid
					,@TipoMovimientoCuentaAhorroid
					,@CuentaAhorroid
					,@Descripcion
					)
			END;

			SET @lo = @lo + 1
		END;

		SELECT @lo = MIN(id)
			,@hi = MAX(id)
		FROM @multasExcesoRetirosCA

		WHILE @lo <= @hi
		BEGIN
			SET @FechaComision = (
					SELECT Fecha
					FROM @multasExcesoRetirosCA
					WHERE id = @lo
					)
			SET @FechaRetirosFin = (
					SELECT DATEADD(DAY, @inNdias, @FechaComision)
					)
			SET @Cuentaid = (
					SELECT CuentaAhorroid
					FROM @multasExcesoRetirosCA
					WHERE id = @lo
					)
			SET @ContadorRetiros = 5
			SET @RetirosPorMes = 0

			SELECT @lo2 = MIN(id)
				,@hi2 = MAX(id)
			FROM @retirosCA

			WHILE @lo2 <= @hi2
			BEGIN
				IF (
						(
							SELECT CuentaAhorroid
							FROM @retirosCA
							WHERE id = @lo2
							) = @Cuentaid
						)
				BEGIN
					IF (
							(
								SELECT Fecha
								FROM @retirosCA
								WHERE id = @lo2
								) >= @FechaComision
							AND (
								SELECT Fecha
								FROM @retirosCA
								WHERE id = @lo2
								) <= @FechaRetirosFin
							)
					BEGIN
						SET @ContadorRetiros = @ContadorRetiros - 1
					END;
				END;

				IF (@ContadorRetiros = 0)
				BEGIN
					SET @Fecha1 = (
							SELECT MIN(Fecha)
							FROM @retirosCA
							WHERE CuentaAhorroid = @Cuentaid
							)
					SET @Fecha2 = (
							SELECT MAX(Fecha)
							FROM @retirosCA
							WHERE CuentaAhorroid = @Cuentaid
							) --Saca el promedio de retiros por mes
					SET @VarPromedioRetirosMes = (
							SELECT COUNT(id)
							FROM @retirosCA
							WHERE CuentaAhorroid = @Cuentaid
							) / DATEDIFF(MONTH, @Fecha1, @Fecha2)
					SET @FechaCasual = @Fecha1

					WHILE @FechaCasual <= @Fecha2
					BEGIN
						SET @RetirosPorMesVAR = (
								SELECT COUNT(id)
								FROM @retirosCA
								WHERE CuentaAhorroid = @Cuentaid
									AND FORMAT(Fecha, 'MM/yyyy') = FORMAT(@FechaCasual, 'MM/yyyy')
								)

						IF (@RetirosPorMesVAR >= @RetirosPorMes)
						BEGIN
							SET @RetirosPorMes = @RetirosPorMesVAR
							SET @VarFechaCantidadMayorRetiros = FORMAT(@FechaCasual, 'MM/yyyy')
						END;

						SET @FechaCasual = DATEADD(MONTH, 1, @FechaCasual)
					END;

					SET @varFechaDeEjecucion = (
							SELECT MAX(Fecha)
							FROM dbo.MovimientoCuentaAhorro
							)

					INSERT INTO @listadoCuentas (
						CuentaAhorroId
						,PromedioRetirosMes
						,FechaCantidadMayorRetiros
						,FechaDeEjecucion
						)
					VALUES (
						@Cuentaid
						,@VarPromedioRetirosMes
						,@VarFechaCantidadMayorRetiros
						,@varFechaDeEjecucion
						)

					SET @lo2 = @hi2 + 1
				END;

				SET @lo2 = @lo2 + 1
			END;

			SET @lo = @lo + 1
		END;

		--SELECT * FROM @multasExcesoRetirosCA
		--SELECT * FROM @retirosCA
		DELETE @listadoCuentas
		WHERE id IN (
				SELECT A.id
				FROM @listadoCuentas A
				INNER JOIN @listadoCuentas B ON A.CuentaAhorroId = B.CuentaAhorroId
					AND A.id > B.id
				)

		SELECT *
		FROM @listadoCuentas

		SET @OutListadoCuentasId = SCOPE_IDENTITY();
		SET @OutResultCode = 0;

		COMMIT TRANSACTION transaccionListadoCuentas;--Finaliza la transacción
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION transaccionListadoCuentas;

		INSERT INTO dbo.Errores --Tabla de Errores
		VALUES (
			SUSER_SNAME()
			,ERROR_NUMBER()
			,ERROR_STATE()
			,ERROR_SEVERITY()
			,ERROR_LINE()
			,ERROR_PROCEDURE()
			,ERROR_MESSAGE()
			,GETDATE()
			);

		SET @OutResultCode = 50005;
	END CATCH

	SET NOCOUNT OFF
END;