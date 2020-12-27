using System;

namespace AppWebBD.Models
{
    public class CuentaObjetivo
    {
        public int id { get; set; }

        public string FechaInicio { get; set; }
        public string FechaFin { get; set; }

        public double Costo { get; set; }

        public string Objetivo { get; set; }
        public double Saldo { get; set; }
        public double InteresesAcumulados { get; set; }
        public int CuentaAhorroid { get; set; }

    }
}
