using AppWebBD.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace AppWebBD.Context
{
    public class SP_Movimiento
    {
        string connectionString = "Data Source=LAPTOP-140FDP4P;Initial Catalog=ProyectoBD1;Integrated Security=true;";//Aqui Solo cambiar el nombre del data source si se cambia de BD
        public IEnumerable<MovimientoCuentaAhorro> MostrarMovimientos(int? estadoCuentaid) //El signo de pregunta sirve para generar un error si el contenido es NULL
        {
            var movimientoLista = new List<MovimientoCuentaAhorro>();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SeleccionarMovimientos", con);
                SqlCommand cmd2 = new SqlCommand("SeleccionarTipoMovimiento", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd2.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@inEstadoCuentaid", estadoCuentaid);
                cmd.Parameters.AddWithValue("@outMovimientoId", 0);
                cmd.Parameters.AddWithValue("@OutResultCode", 0);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    var movimiento = new MovimientoCuentaAhorro();
                    movimiento.id = Convert.ToInt32(dr["id"]);
                    movimiento.Fecha = Convert.ToDateTime(dr["Fecha"]).ToString("d");
                    movimiento.Monto = Convert.ToInt64(dr["Monto"]);
                    movimiento.NuevoSaldo = Convert.ToInt64(dr["NuevoSaldo"]);
                    movimiento.EstadoCuentaid = Convert.ToInt32(dr["EstadoCuentaid"]);
                    movimiento.Nombre = dr["Nombre"].ToString();
                    movimiento.TipoOperacion = dr["TipoOperacion"].ToString();
                    movimiento.Descripcion = dr["Descripcion"].ToString();
                    movimientoLista.Add(movimiento);
                }
                con.Close();
            }
            return movimientoLista;
        }
        public IEnumerable<MovimientoCuentaAhorro> MostrarMovimientosEspecificos(string descripcion,int? estadoCuentaid) //El signo de pregunta sirve para generar un error si el contenido es NULL
        {
            var movimientoLista = new List<MovimientoCuentaAhorro>();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("BuscarMovimientoEspecifico", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@inDescripcion", descripcion);
                cmd.Parameters.AddWithValue("@inEstadoCuentaid", estadoCuentaid);
                cmd.Parameters.AddWithValue("@outMovimientoId", 0);
                cmd.Parameters.AddWithValue("@OutResultCode", 0);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    var movimiento = new MovimientoCuentaAhorro();
                    movimiento.id = Convert.ToInt32(dr["id"]);
                    movimiento.Fecha = Convert.ToDateTime(dr["Fecha"]).ToString("d");
                    movimiento.Monto = Convert.ToInt64(dr["Monto"]);
                    movimiento.NuevoSaldo = Convert.ToInt64(dr["NuevoSaldo"]);
                    movimiento.EstadoCuentaid = Convert.ToInt32(dr["EstadoCuentaid"]);
                    movimiento.Nombre = dr["Nombre"].ToString();
                    movimiento.TipoOperacion = dr["TipoOperacion"].ToString();
                    movimiento.Descripcion = dr["Descripcion"].ToString();
                    movimientoLista.Add(movimiento);
                }
                con.Close();
            }
            return movimientoLista;
        }
    }
}
