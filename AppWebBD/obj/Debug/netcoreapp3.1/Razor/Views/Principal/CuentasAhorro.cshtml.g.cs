#pragma checksum "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\CuentasAhorro.cshtml" "{ff1816ec-aa5e-4d10-87f7-6f4963833460}" "4cba58f2e7e60174c5dc94cb48c7605e50a3af58"
// <auto-generated/>
#pragma warning disable 1591
[assembly: global::Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItemAttribute(typeof(AspNetCore.Views_Principal_CuentasAhorro), @"mvc.1.0.view", @"/Views/Principal/CuentasAhorro.cshtml")]
namespace AspNetCore
{
    #line hidden
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.AspNetCore.Mvc;
    using Microsoft.AspNetCore.Mvc.Rendering;
    using Microsoft.AspNetCore.Mvc.ViewFeatures;
#nullable restore
#line 1 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\_ViewImports.cshtml"
using AppWebBD;

#line default
#line hidden
#nullable disable
#nullable restore
#line 2 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\_ViewImports.cshtml"
using AppWebBD.Models;

#line default
#line hidden
#nullable disable
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"4cba58f2e7e60174c5dc94cb48c7605e50a3af58", @"/Views/Principal/CuentasAhorro.cshtml")]
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"f23a3017679a57eb646949b40ff63d2e4c81b9fc", @"/Views/_ViewImports.cshtml")]
    public class Views_Principal_CuentasAhorro : global::Microsoft.AspNetCore.Mvc.Razor.RazorPage<IEnumerable<AppWebBD.Models.CuentaAhorro>>
    {
        #pragma warning disable 1998
        public async override global::System.Threading.Tasks.Task ExecuteAsync()
        {
            WriteLiteral("\r\n");
#nullable restore
#line 3 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\CuentasAhorro.cshtml"
  
    ViewData["Title"] = "CuentasAhorro";
    Layout = "~/Views/Shared/_LayoutUsuario.cshtml";

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n<h1>CuentasAhorro</h1>\r\n<table class=\"table\">\r\n    <thead>\r\n        <tr>\r\n            <th>\r\n                Persona id\r\n            </th>\r\n            <th>\r\n                ");
#nullable restore
#line 16 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\CuentasAhorro.cshtml"
           Write(Html.DisplayNameFor(model => model.NumeroCuenta));

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n            </th>\r\n            <th>\r\n                ");
#nullable restore
#line 19 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\CuentasAhorro.cshtml"
           Write(Html.DisplayNameFor(model => model.FechaCreacion));

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n            </th>\r\n            <th>\r\n                ");
#nullable restore
#line 22 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\CuentasAhorro.cshtml"
           Write(Html.DisplayNameFor(model => model.Saldo));

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n            </th>\r\n            <th></th>\r\n        </tr>\r\n    </thead>\r\n    <tbody>\r\n");
#nullable restore
#line 28 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\CuentasAhorro.cshtml"
 foreach (var item in Model) {

#line default
#line hidden
#nullable disable
            WriteLiteral("        <tr>\r\n            <td>\r\n                ");
#nullable restore
#line 31 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\CuentasAhorro.cshtml"
           Write(Html.DisplayFor(modelItem => item.Personaid));

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n            </td>\r\n            <td>\r\n                ");
#nullable restore
#line 34 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\CuentasAhorro.cshtml"
           Write(Html.DisplayFor(modelItem => item.NumeroCuenta));

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n            </td>\r\n            <td>\r\n                ");
#nullable restore
#line 37 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\CuentasAhorro.cshtml"
           Write(Html.DisplayFor(modelItem => item.FechaCreacion));

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n            </td>\r\n            <td>\r\n                ");
#nullable restore
#line 40 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\CuentasAhorro.cshtml"
           Write(Html.DisplayFor(modelItem => item.Saldo));

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n            </td>\r\n            <td>\r\n                ");
#nullable restore
#line 43 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\CuentasAhorro.cshtml"
           Write(Html.ActionLink("Ver los Beneficiarios", "verBeneficiarios", new { numeroCuenta = item.NumeroCuenta }));

#line default
#line hidden
#nullable disable
            WriteLiteral("<br />\r\n                ");
#nullable restore
#line 44 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\CuentasAhorro.cshtml"
           Write(Html.ActionLink("Ver Estado de Cuenta", "verEstadoDeCuenta", new { numeroCuenta = item.NumeroCuenta }));

#line default
#line hidden
#nullable disable
            WriteLiteral("<br />\r\n                ");
#nullable restore
#line 45 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\CuentasAhorro.cshtml"
           Write(Html.ActionLink("Agregar Beneficiario", "agregarBeneficiario", new { Personaid = item.Personaid, CuentaAhorroid = item.id, numeroCuenta = item.NumeroCuenta }));

#line default
#line hidden
#nullable disable
            WriteLiteral("<br />\r\n                ");
#nullable restore
#line 46 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\CuentasAhorro.cshtml"
           Write(Html.ActionLink("Tipo de Cuenta", "verTipoCuenta", new { id = item.TipoCuentaid }));

#line default
#line hidden
#nullable disable
            WriteLiteral("<br />\r\n                ");
#nullable restore
#line 47 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\CuentasAhorro.cshtml"
           Write(Html.ActionLink("Crear Cuenta Objetivo", "crearCuentaObjetivo", new { CuentaAhorroid = item.id, Saldo = item.Saldo, InteresesAcumulados = 0 }));

#line default
#line hidden
#nullable disable
            WriteLiteral("<br />\r\n                ");
#nullable restore
#line 48 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\CuentasAhorro.cshtml"
           Write(Html.ActionLink("Ver Cuenta Objetivo", "verCuentaObj", new { cuentaAhorroId = item.id }));

#line default
#line hidden
#nullable disable
            WriteLiteral("<br />\r\n            </td>\r\n        </tr>\r\n");
#nullable restore
#line 51 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\CuentasAhorro.cshtml"
}

#line default
#line hidden
#nullable disable
            WriteLiteral("    </tbody>\r\n</table>\r\n\r\n");
        }
        #pragma warning restore 1998
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.ViewFeatures.IModelExpressionProvider ModelExpressionProvider { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.IUrlHelper Url { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.IViewComponentHelper Component { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.Rendering.IJsonHelper Json { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<IEnumerable<AppWebBD.Models.CuentaAhorro>> Html { get; private set; }
    }
}
#pragma warning restore 1591
