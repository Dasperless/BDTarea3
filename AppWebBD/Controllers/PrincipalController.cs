using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using AppWebBD.Context;
using AppWebBD.Models;

namespace AppWebBD.Controllers
{
    public class PrincipalController : Controller
    {
        SP_Cliente SP_ProcedureCliente = new SP_Cliente();
        SP_Usuario SP_ProcedureUsuario = new SP_Usuario();
        SP_CuentaAhorro SP_ProcedureCuentaAhorro = new SP_CuentaAhorro();
        SP_Beneficiario SP_ProcedureBeneficiario = new SP_Beneficiario();
        SP_Parentezco SP_ProcedureParentezco = new SP_Parentezco();
        SP_EstadoCuenta SP_ProcedureEstadoCuenta = new SP_EstadoCuenta();
        SP_VerificarPorcentajeBeneficiarios SP_ProcedureVerificarPorcentajeBeneficiarios = new SP_VerificarPorcentajeBeneficiarios();
        SP_TipoCuentaAhorro SP_ProcedureTipoCuentaAhorro = new SP_TipoCuentaAhorro();
        SP_CuentaObjetivo SP_ProcedureCuentaObjetivo = new SP_CuentaObjetivo();
        SP_Movimiento SP_ProcedureMovimiento = new SP_Movimiento();
        SP_Consultas SP_consultas = new SP_Consultas();
        public static Usuario usuarioFijo { get; set; } = null;
        public static int cedulaAnterior { get; set; } = 0;
        public static int auxIS { get; set; }  = 0;
        public IActionResult Index()
        {
            return View();
        }
        public ActionResult Details(int ValorDocIdentidad)
        {
            if (ValorDocIdentidad <= 0) return NotFound();
            Cliente cliente = SP_ProcedureCliente.SeleccionarClientePorCedula(ValorDocIdentidad);
            if (cliente == null)
            {
                return NotFound();
            }
            return View(cliente);
        }
        public ActionResult Login()
        {
            return View();
        }
        [HttpPost, ActionName("Login")]
        public ActionResult LoginConfirmed(string user,string pass)
        {
            Usuario usuario = SP_ProcedureUsuario.verUsuario(user, pass);
            usuarioFijo = usuario;
            if (usuario.NombreUsuario != null)
            {
                return CuentasAhorro(usuario);
            }
            else
            {
                string errorLoginMsg = "El usuario o contraseña no son válidos.";    //Mensaje de error.
                TempData["ErrorLogin"] = errorLoginMsg;                         //Tempdata, guarda el mensaje de error.
                return RedirectToAction("Login");
            }
        }

        public ActionResult CuentasAhorro(Usuario usuario)
        {
            if (usuario.EsAdmi == 0)
            {
                Cliente cliente = SP_ProcedureCliente.SeleccionarClientePorCedula(usuario.ValorDocIdentidad);
                List<CuentaAhorro> cuentaList = SP_ProcedureCuentaAhorro.SeleccionarCuentaPorCedula(cliente.id).ToList();
                return View("CuentasAhorro", cuentaList);
            }
            else
            {
                List<CuentaAhorro> cuentaList = SP_ProcedureCuentaAhorro.ObtenerTodasLasCuentas().ToList();
                return View("CuentasAhorro", cuentaList);
            }
        }
        public ActionResult verConsulta1()
        {
            List<Consulta1> cons1List = SP_consultas.SeleccionarConsulta1().ToList();
            return View(cons1List);
        }
        public ActionResult nDias()
        {
            return View();
        }

        [HttpPost, ActionName("verConsulta2")]
        public ActionResult verConsulta2(int cantDias)
        {
            List<Consulta2> cons2List = SP_consultas.SeleccionarConsulta2(cantDias).ToList();
            return View(cons2List);
        }
        public ActionResult verConsulta3()
        {
            List<Consulta3> cons3List = SP_consultas.SeleccionarConsulta3().ToList();
            return View(cons3List);
        }
        public ActionResult verBeneficiarios(int numeroCuenta)
        {
            List<Beneficiarios> beneficariosList = SP_ProcedureBeneficiario.SeleccionarBeneficiarios(numeroCuenta).ToList();
            List<Cliente> clientesList = new List<Cliente>();
            List<Parentezco> parentezcoList = new List<Parentezco>();
            foreach (var item in beneficariosList)
            {
                Cliente cliente = SP_ProcedureCliente.SeleccionarClientePorCedula(item.ValorDocumentoIdentidadBeneficiario);
                clientesList.Add(cliente);
                Parentezco parentezco = SP_ProcedureParentezco.SeleccionarParentezco(item.ParentezcoId);
                parentezcoList.Add(parentezco);
            }
            Tablas tabla = new Tablas();
            tabla.ListaDeBeneficiarios = beneficariosList;
            tabla.ListaDeClientes = clientesList;
            tabla.ListaDeParentezcos = parentezcoList;

            TempData["WarningPorcentage"] = SP_ProcedureVerificarPorcentajeBeneficiarios.VerificarPorcentaje(numeroCuenta); ;                        
            return View("verBeneficiarios",tabla);
        }
        public ActionResult volverIndex()
        {
            return LoginConfirmed(usuarioFijo.NombreUsuario, usuarioFijo.Pass);
        }
        public ActionResult verEstadoDeCuenta(int numeroCuenta)
        {
            List<EstadoCuenta> estadosCuentasList = SP_ProcedureEstadoCuenta.SeleccionarEstadoDeCuenta(numeroCuenta).ToList();
            return View(estadosCuentasList);
        }
        public ActionResult verTipoCuenta(int id)
        {
            TipoCuentaAhorro tipoCuenta = SP_ProcedureTipoCuentaAhorro.SeleccionarTipoCuenta(id);
            tipoCuenta = SP_ProcedureTipoCuentaAhorro.SeleccionarMoneda(id, tipoCuenta);
            return View(tipoCuenta);
        }
        public ActionResult agregarBeneficiario(int Personaid,int CuentaAhorroid, int numeroCuenta)
        {
            return View();
        }

        [HttpPost, ActionName("agregarBeneficiario")]
        public ActionResult agregarBeneficiario([Bind]Beneficiarios beneficiario)
        {
            if (ModelState.IsValid)
            {
                SP_ProcedureBeneficiario.AgregarBeneficiario(beneficiario);
                return RedirectToAction("volverIndex");
            }
            return NotFound();
        }
        public ActionResult agregarCliente()
        {
            return View();
        }
        [HttpPost, ActionName("agregarCliente")]
        public ActionResult agregarCliente([Bind]Cliente cliente)
        {
            if (ModelState.IsValid)
            {
                SP_ProcedureCliente.IngresarCliente(cliente);
                return RedirectToAction("volverIndex");

            }
            return NotFound();

        }
        public ActionResult editarBeneficiario(int ValorDocumentoIdentidadBeneficiario)
        {
            cedulaAnterior = ValorDocumentoIdentidadBeneficiario;
            Beneficiarios beneficiario = SP_ProcedureBeneficiario.SeleccionarBeneficiarioPorCedula(ValorDocumentoIdentidadBeneficiario);
            if (beneficiario != null)
                return View(beneficiario);
            else
                return NotFound();   
        }
        [HttpPost, ActionName("editarBeneficiario")]
        public ActionResult editarBeneficiario([Bind]Beneficiarios beneficiario)
        {
            if (ModelState.IsValid)
            {
                SP_ProcedureBeneficiario.EditarBeneficiario(beneficiario);
                return RedirectToAction("volverIndex");
            }
            return NotFound();
        }
        public ActionResult eliminarBeneficiario(int ValorDocumentoIdentidadBeneficiario,int numeroCuenta)
        {
            Beneficiarios beneficiario = SP_ProcedureBeneficiario.SeleccionarBeneficiarioPorCedula(ValorDocumentoIdentidadBeneficiario);
            if (beneficiario != null)
                return View(beneficiario);
            else
                return NotFound();
        }
        public ActionResult eliminarConfirmed(int id,int numeroCuenta)
        {
            try
            {
                SP_ProcedureBeneficiario.EliminarBeneficiario(id);
                return verBeneficiarios(numeroCuenta);
            }
            catch
            {
                return NotFound();
            }
        }
        public ActionResult crearCuentaObjetivo(int CuentaAhorroid,int Saldo,int InteresesAcumulados)
        {
            return View();
        }

        [HttpPost, ActionName("crearCuentaObjetivo")]
        public ActionResult crearCuentaObjetivo([Bind] CuentaObjetivo caObjetivo)
        {
            if (ModelState.IsValid)
            {
                SP_ProcedureCuentaObjetivo.AgregarCuentaObjetivo(caObjetivo);
                return RedirectToAction("volverIndex");
            }
            return NotFound();
        }
        public ActionResult verCuentaObj(int cuentaAhorroId)
        {
            List<CuentaObjetivo> listaCO =  SP_ProcedureCuentaObjetivo.verCuentaObjetivo(cuentaAhorroId).ToList();
            return View(listaCO);
        }
        public ActionResult editarCuentaObj(int id)
        {
            CuentaObjetivo cuentaObj = SP_ProcedureCuentaObjetivo.seleccionarCAObj(id);
            if (cuentaObj != null)
                return View();
            else
                return NotFound();
        }
        [HttpPost, ActionName("editarCuentaObj")]
        public ActionResult editarCuentaObj([Bind] CuentaObjetivo cuentaObj)
        {
            if (ModelState.IsValid)
            {
                SP_ProcedureCuentaObjetivo.editarDescripcion(cuentaObj);
                return RedirectToAction("volverIndex");
            }
            return NotFound();
        }
        public ActionResult desactivarCuentaObj(int id)
        {
            SP_ProcedureCuentaObjetivo.eliminarCuentaObj(id);
            return RedirectToAction("volverIndex");
        }
        public ActionResult mostrarMovimientos(int EstadoCuentaid)
        {
            List<MovimientoCuentaAhorro> listaMov = SP_ProcedureMovimiento.MostrarMovimientos(EstadoCuentaid).ToList();
            return View(listaMov);
        }
        public ActionResult movimientos(int EstadoCuentaid)
        {
            auxIS = EstadoCuentaid;
            return View();
        }
        [HttpPost, ActionName("movimientoEspecifico")]
        public ActionResult movimientoEspecifico(int EstadoCuentaid, string descripcion)
        {
            EstadoCuentaid = auxIS;
            List<MovimientoCuentaAhorro> listaMov2 = SP_ProcedureMovimiento.MostrarMovimientosEspecificos(descripcion, EstadoCuentaid).ToList();
            return View(listaMov2);
        }
    }

}
