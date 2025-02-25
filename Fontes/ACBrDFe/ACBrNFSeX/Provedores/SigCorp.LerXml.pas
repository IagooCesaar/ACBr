{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatu� - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit SigCorp.LerXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrXmlDocument,
  ACBrNFSeXLerXml_ABRASFv2;

type
  { TNFSeR_SigCorp203 }

  TNFSeR_SigCorp203 = class(TNFSeR_ABRASFv2)
  protected
    function LerDataHoraCancelamento(const ANode: TACBrXmlNode): TDateTime; override;
    function LerDataEmissao(const ANode: TACBrXmlNode): TDateTime; override;
    function LerDataEmissaoRps(const ANode: TACBrXmlNode): TDateTime; override;

    function NormatizarXml(const aXml: string): string; override;
  public

  end;

implementation

uses
  ACBrXmlBase,
  ACBrUtil.Strings, ACBrUtil.DateTime;

//==============================================================================
// Essa unit tem por finalidade exclusiva ler o XML do provedor:
//     SigCorp
//==============================================================================

{ TNFSeR_SigCorp203 }

function TNFSeR_SigCorp203.LerDataEmissao(const ANode: TACBrXmlNode): TDateTime;
var
  xDataHora, xFormato: string;
begin
  xDataHora := ObterConteudo(ANode.Childrens.FindAnyNs('DataEmissao'), tcStr);
  xFormato := 'YYYY/MM/DD';

  if FpAOwner.ConfigGeral.Params.ParamTemValor('FormatoData', 'NFSeDDMMAAAA') then
    xFormato := 'DD/MM/YYYY';

  if FpAOwner.ConfigGeral.Params.ParamTemValor('FormatoData', 'NFSeMMDDAAAA') then
    xFormato := 'MM/DD/YYYY';

  result := EncodeDataHora(xDataHora, xFormato);
end;

function TNFSeR_SigCorp203.LerDataEmissaoRps(
  const ANode: TACBrXmlNode): TDateTime;
var
  xDataHora, xFormato: string;
begin
  xDataHora := ObterConteudo(ANode.Childrens.FindAnyNs('DataEmissao'), tcStr);
  xFormato := 'YYYY/MM/DD';

  if FpAOwner.ConfigGeral.Params.ParamTemValor('FormatoData', 'RpsDDMMAAAA') then
    xFormato := 'DD/MM/YYYY';

  if FpAOwner.ConfigGeral.Params.ParamTemValor('FormatoData', 'RpsMMDDAAAA') then
    xFormato := 'MM/DD/YYYY';

  result := EncodeDataHora(xDataHora, xFormato);
end;

function TNFSeR_SigCorp203.LerDataHoraCancelamento(
  const ANode: TACBrXmlNode): TDateTime;
var
  xDataHora, xFormato: string;
begin
  xDataHora := ObterConteudo(ANode.Childrens.FindAnyNs('DataHoraCancelamento'), tcStr);
  xFormato := 'YYYY/MM/DD';

  if FpAOwner.ConfigGeral.Params.ParamTemValor('FormatoData', 'CancDDMMAAAA') then
    xFormato := 'DD/MM/YYYY';

  if FpAOwner.ConfigGeral.Params.ParamTemValor('FormatoData', 'CancMMDDAAAA') then
    xFormato := 'MM/DD/YYYY';

  result := EncodeDataHora(xDataHora, xFormato);
end;

function TNFSeR_SigCorp203.NormatizarXml(const aXml: string): string;
begin
  Result := inherited NormatizarXml(aXml);

  Result := StringReplace(Result, '&', '&amp;', [rfReplaceAll]);
end;

end.
