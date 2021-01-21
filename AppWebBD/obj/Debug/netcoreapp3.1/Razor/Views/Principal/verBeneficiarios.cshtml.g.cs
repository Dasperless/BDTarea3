#pragma checksum "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\verBeneficiarios.cshtml" "{ff1816ec-aa5e-4d10-87f7-6f4963833460}" "5e649fe17ac6cd50b72335850d070e8dd0a2f98b"
// <auto-generated/>
#pragma warning disable 1591
[assembly: global::Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItemAttribute(typeof(AspNetCore.Views_Principal_verBeneficiarios), @"mvc.1.0.view", @"/Views/Principal/verBeneficiarios.cshtml")]
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
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"5e649fe17ac6cd50b72335850d070e8dd0a2f98b", @"/Views/Principal/verBeneficiarios.cshtml")]
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"f23a3017679a57eb646949b40ff63d2e4c81b9fc", @"/Views/_ViewImports.cshtml")]
    public class Views_Principal_verBeneficiarios : global::Microsoft.AspNetCore.Mvc.Razor.RazorPage<AppWebBD.Models.Tablas>
    {
        #pragma warning disable 1998
        public async override global::System.Threading.Tasks.Task ExecuteAsync()
        {
            WriteLiteral("\r\n");
#nullable restore
#line 3 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\verBeneficiarios.cshtml"
  
    ViewData["Title"] = "verBeneficiarios";
    Layout = "~/Views/Shared/_LayoutUsuario.cshtml";

#line default
#line hidden
#nullable disable
#nullable restore
#line 7 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\verBeneficiarios.cshtml"
  
    List<Beneficiarios> listaBeneficiario = Model.ListaDeBeneficiarios;
    List<Cliente> listaCliente = Model.ListaDeClientes;
    List<Parentezco> listaParentezco = Model.ListaDeParentezcos;    

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n");
#nullable restore
#line 13 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\verBeneficiarios.cshtml"
  
    if(@TempData["WarningPorcentage"]!= null){

#line default
#line hidden
#nullable disable
            WriteLiteral("        <div class=\"alert alert-warning alert-dismissible fade show\" role=\"alert\">\r\n            ");
#nullable restore
#line 16 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\verBeneficiarios.cshtml"
       Write(TempData["WarningPorcentage"]);

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n            <button type=\"button\" class=\"close\" data-dismiss=\"alert\" aria-label=\"Close\">\r\n               <span aria-hidden=\"true\">&times;</span>\r\n            </button>\r\n        </div>\r\n");
#nullable restore
#line 21 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\verBeneficiarios.cshtml"
    }

#line default
#line hidden
#nullable disable
            WriteLiteral(@"
<h1>Beneficiarios</h1>

<table class=""table"">
    <thead>
        <tr>
            <th>
                Ligado a la cuenta
            </th>
            <th>
                Nombre
            </th>
            <th>
                Identificación
            </th>
            <th>
                Email
            </th>
            <th>
                Fecha De Nacimiento
            </th>
            <th>
                Telefono1
            </th>
            <th>
                Telefono2
            </th>
            <th>
                Parentezco
            </th>
            <th>
                Porcentaje
            </th>
            <th></th>
        </tr>
    </thead>
    <tbody>
");
#nullable restore
#line 60 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\verBeneficiarios.cshtml"
         for (int i = 0; i < listaBeneficiario.Count; i++)
        {

#line default
#line hidden
#nullable disable
            WriteLiteral("            <tr>\r\n                <td>\r\n                    ");
#nullable restore
#line 64 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\verBeneficiarios.cshtml"
               Write(listaBeneficiario[i].NumeroCuenta);

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n                </td>\r\n                <td>\r\n                    ");
#nullable restore
#line 67 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\verBeneficiarios.cshtml"
               Write(listaCliente[i].Nombre);

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n                </td>\r\n                <td>\r\n                    ");
#nullable restore
#line 70 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\verBeneficiarios.cshtml"
               Write(listaBeneficiario[i].ValorDocumentoIdentidadBeneficiario);

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n                </td>\r\n                <td>\r\n                    ");
#nullable restore
#line 73 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\verBeneficiarios.cshtml"
               Write(listaCliente[i].Email);

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n                </td>\r\n                <td>\r\n                    ");
#nullable restore
#line 76 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\verBeneficiarios.cshtml"
               Write(listaCliente[i].FechaNacimiento);

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n                </td>\r\n                <td>\r\n                    ");
#nullable restore
#line 79 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\verBeneficiarios.cshtml"
               Write(listaCliente[i].Telefono1);

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n                </td>\r\n                <td>\r\n                    ");
#nullable restore
#line 82 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\verBeneficiarios.cshtml"
               Write(listaCliente[i].Telefono2);

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n                </td>\r\n                <td>\r\n                    ");
#nullable restore
#line 85 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\verBeneficiarios.cshtml"
               Write(listaParentezco[i].Nombre);

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n                </td>\r\n                <td>\r\n                    ");
#nullable restore
#line 88 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\verBeneficiarios.cshtml"
               Write(listaBeneficiario[i].Porcentaje);

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n                </td>\r\n                <td>\r\n                    ");
#nullable restore
#line 91 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\verBeneficiarios.cshtml"
               Write(Html.ActionLink("Editar", "editarBeneficiario", new { ValorDocumentoIdentidadBeneficiario = @listaBeneficiario[i].ValorDocumentoIdentidadBeneficiario }));

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n                    ");
#nullable restore
#line 92 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\verBeneficiarios.cshtml"
               Write(Html.ActionLink("\nEliminar", "eliminarBeneficiario", new { ValorDocumentoIdentidadBeneficiario = @listaBeneficiario[i].ValorDocumentoIdentidadBeneficiario, numeroCuenta = @listaBeneficiario[i].NumeroCuenta }));

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n                </td>\r\n            </tr>\r\n");
#nullable restore
#line 95 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\verBeneficiarios.cshtml"
        }

#line default
#line hidden
#nullable disable
            WriteLiteral("    </tbody>\r\n</table>\r\n");
#nullable restore
#line 98 "C:\Users\yeico\Desktop\BDTarea3\AppWebBD\Views\Principal\verBeneficiarios.cshtml"
Write(Html.ActionLink("<--Volver", "volverIndex", new { }));

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n");
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
        public global::Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<AppWebBD.Models.Tablas> Html { get; private set; }
    }
}
#pragma warning restore 1591
