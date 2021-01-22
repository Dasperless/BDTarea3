using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AppWebBD.Models
{
    public class Consulta1
    {
		public int id { get; set; }
		public int COId { get; set; }
		public int CACodigo { get; set; }
		public string descripción { get; set; }
		public int cantDepositosR { get; set; }
		public int cantDepositosT { get; set; }
		public double montoDebitadoReal { get; set; }
		public double montoDebitadoTotal { get; set; }
	}
}
