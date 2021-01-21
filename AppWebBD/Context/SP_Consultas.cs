using AppWebBD.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace AppWebBD.Context
{
    public class SP_Consultas
    {
        string connectionString = "Data Source=LAPTOP-140FDP4P;Initial Catalog=ProyectoBD1;Integrated Security=true;";
        public IEnumerable<Consulta2> SeleccionarConsulta2(int? Ndias) 
        {
            var listaConsulta2 = new List<Consulta2>();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("Consulta2", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@inNdias", Ndias);
                cmd.Parameters.AddWithValue("@OutListadoCuentasId", 0);
                cmd.Parameters.AddWithValue("@OutResultCode", 0);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    var datosConsulta2 = new Consulta2();
                    datosConsulta2.id = Convert.ToInt32(dr["id"]);
                    datosConsulta2.CuentaAhorroId = Convert.ToInt32(dr["CuentaAhorroId"]);
                    datosConsulta2.PromedioRetirosMes = Convert.ToInt32(dr["PromedioRetirosMes"]);
                    datosConsulta2.FechaCantidadMayorRetiros = dr["FechaCantidadMayorRetiros"].ToString();
                    datosConsulta2.FechaDeEjecucion = Convert.ToDateTime(dr["FechaDeEjecucion"]).ToString("d");
                    listaConsulta2.Add(datosConsulta2);
                }
                con.Close();
            }
            return listaConsulta2;
        }
        public IEnumerable<Consulta3> SeleccionarConsulta3()
        {
            var listaConsulta3 = new List<Consulta3>();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("Consulta3", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@OutListadoBeneficiariosId", 0);
                cmd.Parameters.AddWithValue("@OutResultCode", 0);
                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    var datosConsulta3 = new Consulta3();
                    datosConsulta3.id = Convert.ToInt32(dr["id"]);
                    datosConsulta3.ValorDocIdentidad = Convert.ToInt32(dr["ValorDocIdentidad"]);
                    datosConsulta3.CreditoTotalRecibido = Convert.ToDouble(dr["CreditoTotalRecibido"]);
                    datosConsulta3.MayorAporte = Convert.ToInt32(dr["MayorAporte"]);
                    datosConsulta3.CantidadDeAportes = Convert.ToInt32(dr["CantidadDeAportes"]);
                    listaConsulta3.Add(datosConsulta3);
                }
                con.Close();
            }
            return listaConsulta3;
        }

    }
}
