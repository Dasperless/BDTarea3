

namespace AppWebBD.Models
{
    public class Usuario
    {
        public int id { get; set; }
        public string NombreUsuario { get; set; }
        public string Pass { get; set; }
        public int ValorDocIdentidad { get; set; }
        public int EsAdmi { get; set; }  //Booleano 0 o 1

    }
}
