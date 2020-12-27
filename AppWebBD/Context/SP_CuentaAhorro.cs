using AppWebBD.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace AppWebBD.Context
{
    public class SP_CuentaAhorro
    {
        string connectionString = "Data Source=LAPTOP-140FDP4P;Initial Catalog=ProyectoBD1;Integrated Security=true;";//Aqui Solo cambiar el nombre del data source si se cambia de BD
        public IEnumerable<CuentaAhorro> SeleccionarCuentaPorCedula(int? Personaid) //El signo de pregunta sirve para generar un error si el contenido es NULL
        {
            var cuentaAhorroLista = new List<CuentaAhorro>();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SeleccionarCuentaAhorro", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@inPersonaid", Personaid);
                cmd.Parameters.AddWithValue("@outCuentaAhorroId",0);
                cmd.Parameters.AddWithValue("@OutResultCode", 0);
                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    var cuentaAhorro = new CuentaAhorro();
                    cuentaAhorro.id = Convert.ToInt32(dr["id"]);
                    cuentaAhorro.Personaid = Convert.ToInt32(dr["Personaid"]);
                    cuentaAhorro.TipoCuentaid = Convert.ToInt32(dr["TipoCuentaid"]);
                    cuentaAhorro.NumeroCuenta = Convert.ToInt64(dr["NumeroCuenta"]);
                    cuentaAhorro.FechaCreacion = Convert.ToDateTime(dr["FechaCreacion"]).ToString("d");
                    cuentaAhorro.Saldo = Convert.ToDouble(dr["Saldo"]);
                    cuentaAhorroLista.Add(cuentaAhorro);
                }
                con.Close();
            }
            return cuentaAhorroLista;
        }
        public IEnumerable<CuentaAhorro> ObtenerTodasLasCuentas() //El signo de pregunta sirve para generar un error si el contenido es NULL
        {
            var cuentaAhorroLista = new List<CuentaAhorro>();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SP_TodoCuentaAhorro", con);
                cmd.CommandType = CommandType.StoredProcedure;
                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    var cuentaAhorro = new CuentaAhorro();
                    cuentaAhorro.id = Convert.ToInt32(dr["id"]);
                    cuentaAhorro.Personaid = Convert.ToInt32(dr["Personaid"]);
                    cuentaAhorro.TipoCuentaid = Convert.ToInt32(dr["TipoCuentaid"]);
                    cuentaAhorro.NumeroCuenta = Convert.ToInt64(dr["NumeroCuenta"]);
                    cuentaAhorro.FechaCreacion = Convert.ToDateTime(dr["FechaCreacion"]).ToString("d");
                    cuentaAhorro.Saldo = Convert.ToDouble(dr["Saldo"]);
                    cuentaAhorroLista.Add(cuentaAhorro);
                }
                con.Close();
            }
            return cuentaAhorroLista;
        }
    }
}
