using AppWebBD.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace AppWebBD.Context
{
    public class SP_TipoCuentaAhorro
    {
        string connectionString = "Data Source=LAPTOP-140FDP4P;Initial Catalog=ProyectoBD1;Integrated Security=true;";//Aqui Solo cambiar el nombre del data source si se cambia de BD
        public TipoCuentaAhorro SeleccionarTipoCuenta(int? id) //El signo de pregunta sirve para generar un error si el contenido es NULL
        {
            var tipoCA = new TipoCuentaAhorro();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SP_TipoCuentaAhorro", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@inTipoCuentaAhorroId", id);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    tipoCA.id = Convert.ToInt32(dr["id"]);
                    tipoCA.Nombre = dr["Nombre"].ToString();
                    tipoCA.idTipoMoneda = Convert.ToInt32(dr["IdTipoMoneda"]);
                    tipoCA.SaldoMinimo = Convert.ToDouble(dr["SaldoMinimo"]);
                    tipoCA.MultaSaldoMin = Convert.ToDouble(dr["MultaSaldoMin"]);
                    tipoCA.CargoAnual = Convert.ToDouble(dr["CargoAnual"]);
                    tipoCA.NumRetirosHumano = Convert.ToInt32(dr["NumRetirosHumano"]);
                    tipoCA.NumRetirosAutomatico = Convert.ToInt32(dr["NumRetirosAutomatico"]);
                    tipoCA.ComisionHumano = Convert.ToInt32(dr["ComisionHumano"]);
                    tipoCA.ComisionAutomatico = Convert.ToInt32(dr["ComisionAutomatico"]);
                    tipoCA.Intereses = Convert.ToInt32(dr["Interes"]);
                    tipoCA.NombreMoneda = "";
                    tipoCA.Simbolo = "";
                }
                con.Close();
            }
            return tipoCA;
        }
        public TipoCuentaAhorro SeleccionarMoneda(int? id,TipoCuentaAhorro tipoCA)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SP_TipoMoneda", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@inTipoMonedaId", id);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    tipoCA.NombreMoneda = dr["Nombre"].ToString();
                    tipoCA.Simbolo = dr["Simbolo"].ToString();
                }
                con.Close();
            }
            return tipoCA;
        }

    }
}
