using System;

namespace AppWebBD.Models
{
    public class Beneficiarios
    {
        public int id { get; set; }
        public int Personaid { get; set; }
        public int CuentaAhorroid { get; set; }

        public long NumeroCuenta { get; set; }
        public int ValorDocumentoIdentidadBeneficiario { get; set; }
        public int ParentezcoId { get; set; }
        public int Porcentaje { get; set; }
        public Boolean Activo { get; set; }
        public string FechaDesactivacion { get; set; }

    }
}
