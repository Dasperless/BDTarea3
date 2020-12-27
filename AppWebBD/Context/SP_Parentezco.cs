using AppWebBD.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace AppWebBD.Context
{
    public class SP_Parentezco
    {
        string connectionString = "Data Source=LAPTOP-140FDP4P;Initial Catalog=ProyectoBD1;Integrated Security=true;";//Aqui Solo cambiar el nombre del data source si se cambia de BD
        public Parentezco SeleccionarParentezco(int? ParentezcoId) //El signo de pregunta sirve para generar un error si el contenido es NULL
        {
            var parentezco = new Parentezco();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SP_ObtenerParentezco", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@ParentezcoId", ParentezcoId);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    parentezco.Nombre = dr["Nombre"].ToString();
                }
                con.Close();
            }
            return parentezco;
        }
    }
}
