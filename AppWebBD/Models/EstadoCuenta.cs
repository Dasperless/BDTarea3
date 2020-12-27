

namespace AppWebBD.Models
{
    public class EstadoCuenta
    {
        public int id { get; set; }
        public int CuentaAhorroid { get; set; }
        public int NumeroCuenta { get; set; }
        public string FechaInicio { get; set; }
        public string FechaFin { get; set; }
        public long SaldoInicial { get; set; }
        public long SaldoFinal { get; set; }
    }
}
