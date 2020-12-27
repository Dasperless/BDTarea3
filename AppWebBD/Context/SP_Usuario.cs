using AppWebBD.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace AppWebBD.Context
{
    public class SP_Usuario
    {
        string connectionString = "Data Source=LAPTOP-140FDP4P;Initial Catalog=ProyectoBD1;Integrated Security=true;";//Aqui Solo cambiar el nombre del data source si se cambia de BD
        public Usuario verUsuario(string User,string Pass) //Revisa si el usuario y contraseña ingresados pertenece a la base de datos.
        {
            var usuario = new Usuario();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SP_CompararUsuario", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Usuario", User);
                cmd.Parameters.AddWithValue("@Pass", Pass);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    usuario.id = Convert.ToInt32(dr["id"]);
                    usuario.NombreUsuario = dr["NombreUsuario"].ToString();
                    usuario.Pass = dr["Pass"].ToString();
                    usuario.ValorDocIdentidad = Convert.ToInt32(dr["ValorDocIdentidad"].ToString());
                    usuario.EsAdmi = Convert.ToInt32(dr["EsAdmi"]);
                }
                con.Close();
            }
            return usuario;
        }
    }
}
