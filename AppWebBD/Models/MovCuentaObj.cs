using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AppWebBD.Models
{
    public class MovCuentaObj
    {
        public int id { get; set; }
        public string Fecha { get; set; }
        public double Monto { get; set; }
        public int TipoMovObjid { get; set; }
        public int CuentaObjetivoid { get; set; }

    }
}
