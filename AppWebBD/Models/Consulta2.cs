using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AppWebBD.Models
{
    public class Consulta2
    {
        public int id { get; set; }
        public int CuentaAhorroId { get; set; }
        public int PromedioRetirosMes { get; set; }
        public string FechaCantidadMayorRetiros { get; set; }
        public string FechaDeEjecucion { get; set; }
    }
}
