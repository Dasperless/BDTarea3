using AppWebBD.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace AppWebBD.Context
{
    public class SP_Beneficiario
    {
        string connectionString = "Data Source=LAPTOP-140FDP4P;Initial Catalog=ProyectoBD1;Integrated Security=true;";//Aqui Solo cambiar el nombre del data source si se cambia de BD
        public IEnumerable<Beneficiarios> SeleccionarBeneficiarios(int? NumeroCuenta) //El signo de pregunta sirve para generar un error si el contenido es NULL
        {
            var beneficiarioLista = new List<Beneficiarios>();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SP_ObtenerBeneficiarios", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@NumeroCuenta", NumeroCuenta);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    var beneficiario = new Beneficiarios();
                    beneficiario.id = Convert.ToInt32(dr["id"]);
                    beneficiario.Personaid = Convert.ToInt32(dr["Personaid"]);
                    beneficiario.CuentaAhorroid = Convert.ToInt32(dr["CuentaAhorroid"]);
                    beneficiario.NumeroCuenta = Convert.ToInt32(dr["NumeroCuenta"]);
                    beneficiario.ValorDocumentoIdentidadBeneficiario = Convert.ToInt32(dr["ValorDocumentoIdentidadBeneficiario"]);
                    beneficiario.ParentezcoId = Convert.ToInt32(dr["ParentezcoId"]);
                    beneficiario.Porcentaje = Convert.ToInt32(dr["Porcentaje"]);
                    beneficiario.Activo = Convert.ToBoolean(dr["Activo"]);
                    if(beneficiario.FechaDesactivacion!=null)
                        beneficiario.FechaDesactivacion = Convert.ToDateTime(dr["FechaDesactivacion"]).ToString("d");
                    if(beneficiario.Activo)
                        beneficiarioLista.Add(beneficiario);
                }
                con.Close();
            }
            return beneficiarioLista;
        }

        public Beneficiarios SeleccionarBeneficiarioPorCedula(int? ValorDocumentoIdentidadBeneficiario) //El signo de pregunta sirve para generar un error si el contenido es NULL
        {
            var beneficiario = new Beneficiarios();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SP_BeneficiarioPorID", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@ValorDocumentoIdentidadBeneficiario", ValorDocumentoIdentidadBeneficiario);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    beneficiario.id = Convert.ToInt32(dr["id"]);
                    beneficiario.Personaid = Convert.ToInt32(dr["Personaid"]);
                    beneficiario.CuentaAhorroid = Convert.ToInt32(dr["CuentaAhorroid"]);
                    beneficiario.NumeroCuenta = Convert.ToInt32(dr["NumeroCuenta"]);
                    beneficiario.ValorDocumentoIdentidadBeneficiario = Convert.ToInt32(dr["ValorDocumentoIdentidadBeneficiario"]);
                    beneficiario.ParentezcoId = Convert.ToInt32(dr["ParentezcoId"]);
                    beneficiario.Porcentaje = Convert.ToInt32(dr["Porcentaje"]);
                    beneficiario.Activo = Convert.ToBoolean(dr["Activo"]);
                    if (beneficiario.FechaDesactivacion != null)
                        beneficiario.FechaDesactivacion = Convert.ToDateTime(dr["FechaDesactivacion"]).ToString("d");
                }
                con.Close();
            }
            if (beneficiario.Activo)
                return beneficiario;
            else
                return null;
        }
        public void EliminarBeneficiario(int? id)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SP_EliminarBeneficiario", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@inId", id);
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }

        }
        public void AgregarBeneficiario(Beneficiarios beneficiario)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                System.Diagnostics.Debug.WriteLine("A veteer" + beneficiario.Personaid);
                SqlCommand cmd = new SqlCommand("InsertarBeneficiarios", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@inPersonaId", beneficiario.Personaid);
                cmd.Parameters.AddWithValue("@inCuentaAhorroId", beneficiario.CuentaAhorroid);
                cmd.Parameters.AddWithValue("@inNumeroCuenta", beneficiario.NumeroCuenta);
                cmd.Parameters.AddWithValue("@inValorDocumentoIdentidadBeneficiario", beneficiario.ValorDocumentoIdentidadBeneficiario);
                cmd.Parameters.AddWithValue("@inParentezcoId", beneficiario.ParentezcoId);
                cmd.Parameters.AddWithValue("@inPorcentaje", beneficiario.Porcentaje);
                cmd.Parameters.AddWithValue("@OutMovimientoId", 0);
                cmd.Parameters.AddWithValue("@OutResultCode", 0);


                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }

        }
        public void EditarBeneficiario(Beneficiarios beneficiario) //Recibe Id, personaId, CuentaAhorroId
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("EditarBeneficiario", con); 
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@inId", beneficiario.id);
                cmd.Parameters.AddWithValue("@inNumeroCuenta", beneficiario.NumeroCuenta);
                cmd.Parameters.AddWithValue("@inValorDocumentoIdentidadBeneficiario", beneficiario.ValorDocumentoIdentidadBeneficiario);
                cmd.Parameters.AddWithValue("@inParentezcoId", beneficiario.ParentezcoId);
                cmd.Parameters.AddWithValue("@inPorcentaje", beneficiario.Porcentaje);
                cmd.Parameters.AddWithValue("@outBeneficiarioId", 0);
                cmd.Parameters.AddWithValue("@OutResultCode", 0);
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }

        }
    }
}
