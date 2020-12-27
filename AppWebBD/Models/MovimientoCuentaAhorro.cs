

namespace AppWebBD.Models
{
    public class MovimientoCuentaAhorro
    {
        public int id { get; set; }
        public string Fecha { get; set; }
        public long Monto { get; set; }
        public long NuevoSaldo { get; set; }
        public int EstadoCuentaid { get; set; }
        public string Nombre { get; set; }
        public string TipoOperacion { get; set; }  //debito o credito
        public int CuentaAhorroid { get; set; }
        public string Descripcion { get; set; }
    }
}
