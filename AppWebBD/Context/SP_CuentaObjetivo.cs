using AppWebBD.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace AppWebBD.Context
{
    public class SP_CuentaObjetivo
    {
        string connectionString = "Data Source=LAPTOP-140FDP4P;Initial Catalog=ProyectoBD1;Integrated Security=true;";
        public void AgregarCuentaObjetivo(CuentaObjetivo cuentaObj)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("CrearCuentaObjetivo", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@inFechaInicio", cuentaObj.FechaInicio);
                cmd.Parameters.AddWithValue("@inFechaFin", cuentaObj.FechaFin);
                cmd.Parameters.AddWithValue("@inCosto", cuentaObj.Costo);
                cmd.Parameters.AddWithValue("@inObjetivo", cuentaObj.Objetivo);
                cmd.Parameters.AddWithValue("@inSaldo", cuentaObj.Saldo);
                cmd.Parameters.AddWithValue("@inInteresesAcumulados", cuentaObj.InteresesAcumulados);
                cmd.Parameters.AddWithValue("@inCuentaAhorroid",cuentaObj.CuentaAhorroid);
                cmd.Parameters.AddWithValue("@outCuentaObjetivoId", 0);
                cmd.Parameters.AddWithValue("@OutResultCode", 0);


                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }

        }

        public IEnumerable<CuentaObjetivo> verCuentaObjetivo(int? CuentaAhorroid) //El signo de pregunta sirve para generar un error si el contenido es NULL
        {
            var cuentaObjLista = new List<CuentaObjetivo>();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("VerCuentaObj", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@inCuentaAhorroid",CuentaAhorroid);
                cmd.Parameters.AddWithValue("@outCuentaObjId", 0);
                cmd.Parameters.AddWithValue("@OutResultCode", 0);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    var cuentaObj = new CuentaObjetivo();
                    cuentaObj.id = Convert.ToInt32(dr["id"]);
                    cuentaObj.FechaInicio = Convert.ToDateTime(dr["FechaInicio"]).ToString("d");
                    cuentaObj.FechaFin = Convert.ToDateTime(dr["FechaFin"]).ToString("d");
                    cuentaObj.Costo = Convert.ToDouble(dr["Costo"]);
                    cuentaObj.Objetivo = dr["Objetivo"].ToString();
                    cuentaObj.Saldo = Convert.ToDouble(dr["Saldo"]);
                    cuentaObj.InteresesAcumulados = Convert.ToDouble(dr["InteresesAcumulados"]);
                    cuentaObj.CuentaAhorroid = Convert.ToInt32(dr["CuentaAhorroid"]);
                    
                    cuentaObjLista.Add(cuentaObj);
                }
                con.Close();
            }
            return cuentaObjLista;
        }
        public void editarDescripcion(CuentaObjetivo cuentaObj)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("ModificarDescripcionCuentaObjetivo", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@id",cuentaObj.id);
                cmd.Parameters.AddWithValue("@inObjetivo",cuentaObj.Objetivo);
                cmd.Parameters.AddWithValue("@outCuentaObjetivoId", 0);
                cmd.Parameters.AddWithValue("@OutResultCode", 0);
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }

        }
        public void eliminarCuentaObj(int? id)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("DesactivacionCuentaObjetivo", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@id",id);
                cmd.Parameters.AddWithValue("@outCuentaObjetivoId",0);
                cmd.Parameters.AddWithValue("@OutResultCode",0);
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }
        }
        public CuentaObjetivo seleccionarCAObj(int ? id)
        {
            var cuentaObj = new CuentaObjetivo();
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("selCO", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@id",id);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    cuentaObj.id = Convert.ToInt32(dr["id"]);
                    cuentaObj.FechaInicio = Convert.ToDateTime(dr["FechaInicio"]).ToString("d");
                    cuentaObj.FechaFin = Convert.ToDateTime(dr["FechaFin"]).ToString("d");
                    cuentaObj.Costo = Convert.ToDouble(dr["Costo"]);
                    cuentaObj.Objetivo = dr["Objetivo"].ToString();
                    cuentaObj.Saldo = Convert.ToDouble(dr["Saldo"]);
                    cuentaObj.InteresesAcumulados = Convert.ToDouble(dr["InteresesAcumulados"]);
                    cuentaObj.CuentaAhorroid = Convert.ToInt32(dr["CuentaAhorroid"]);
                }
                con.Close();
            }
            return cuentaObj;
        }
    }
}
