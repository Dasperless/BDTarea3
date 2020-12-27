

namespace AppWebBD.Models
{
    public class TipoCuentaAhorro
    {
        public int id { get; set; }
        public string Nombre { get; set; }
        public int  idTipoMoneda { get; set; }
        public double SaldoMinimo { get; set; }
        public double MultaSaldoMin { get; set; }
        public double CargoAnual { get; set; }
        public int NumRetirosHumano { get; set; }
        public int NumRetirosAutomatico { get; set; }
        public int ComisionHumano { get; set; }
        public int ComisionAutomatico { get; set; }
        public int Intereses { get; set; }
        public string NombreMoneda { get; set; }
        public string Simbolo { get; set; }


    }
}
