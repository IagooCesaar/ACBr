{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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

(*

  Documenta��o
  https://developers.bb.com.br/

*)

{$I ACBr.inc}

unit ACBrPIXPSPBancoDoBrasil;

interface

uses
  Classes, SysUtils,
  ACBrPIXCD, ACBrBase, ACBrPIXSchemasProblema;

const
  cBBParamDevAppKey = 'gw-dev-app-key';
  cBBParamAppKey = 'gw-app-key';
  cBBURLSandbox = 'https://api.hm.bb.com.br';  // 'https://api.sandbox.bb.com.br';
  cBBURLProducao = 'https://api.bb.com.br';
  cBBPathAPIPix = '/pix/v1';
  cBBURLAuthTeste = 'https://oauth.hm.bb.com.br/oauth/token';
  cBBURLAuthProducao = 'https://oauth.bb.com.br/oauth/token';
  cBBPathSandboxPagarPix = '/testes-portal-desenvolvedor/v1';
  cBBEndPointPagarPix = '/boletos-pix/pagar';
  cBBURLSandboxPagarPix = cBBURLSandbox + cBBPathSandboxPagarPix + cBBEndPointPagarPix;
  cBBKeySandboxPagarPix = '95cad3f03fd9013a9d15005056825665';
  cBBEndPointCobHomologacao = '/cobqrcode';

type

  { TACBrPSPBancoDoBrasil }
  
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrPSPBancoDoBrasil = class(TACBrPSP)
  private
    fDeveloperApplicationKey: String;

    procedure QuandoAcessarEndPoint(const AEndPoint: String;
      var AURL: String; var AMethod: String);
    procedure QuandoReceberRespostaEndPoint(const AEndPoint, AURL, AMethod: String;
      var AResultCode: Integer; var RespostaHttp: AnsiString);
  protected
    function ObterURLAmbiente(const Ambiente: TACBrPixCDAmbiente): String; override;
    function CalcularEndPointPath(const aMethod, aEndPoint: String): String; override;

    procedure ConfigurarQueryParameters(const Method, EndPoint: String); override;
    procedure TratarRetornoComErro(ResultCode: Integer; const RespostaHttp: AnsiString;
      Problema: TACBrPIXProblema); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Autenticar; override;

    procedure SimularPagamentoPIX(const pixCopiaECola: String;
      var Code: Integer; var Texto: String);
  published
    property APIVersion;
    property ClientID;
    property ClientSecret;

    property DeveloperApplicationKey: String read fDeveloperApplicationKey
      write fDeveloperApplicationKey;
  end;

implementation

uses
  synautil, synacode,
  ACBrUtil.Strings,
  ACBrJSON,
  ACBrPIXBase,
  DateUtils;

{ TACBrPSPBancoDoBrasil }

constructor TACBrPSPBancoDoBrasil.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fDeveloperApplicationKey := '';
  fpQuandoAcessarEndPoint := QuandoAcessarEndPoint;
  fpQuandoReceberRespostaEndPoint := QuandoReceberRespostaEndPoint;
end;

procedure TACBrPSPBancoDoBrasil.Autenticar;
var
  AURL, Body, BasicAutentication: String;
  RespostaHttp: AnsiString;
  ResultCode, sec: Integer;
  js: TACBrJSONObject;
  qp: TACBrQueryParams;
begin
  LimparHTTP;

  if (ACBrPixCD.Ambiente = ambProducao) then
    AURL := cBBURLAuthProducao
  else
    AURL := cBBURLAuthTeste;

  qp := TACBrQueryParams.Create;
  try
    qp.Values['grant_type'] := 'client_credentials';
    qp.Values['scope'] := 'cob.read cob.write pix.read pix.write';
    Body := qp.AsURL;
    WriteStrToStream(Http.Document, Body);
    Http.MimeType := CContentTypeApplicationWwwFormUrlEncoded;
  finally
    qp.Free;
  end;

  BasicAutentication := 'Basic '+EncodeBase64(ClientID + ':' + ClientSecret);
  Http.Headers.Add(ChttpHeaderAuthorization+' '+BasicAutentication);
  TransmitirHttp(ChttpMethodPOST, AURL, ResultCode, RespostaHttp);

  if (ResultCode = HTTP_OK) then
  begin
    js := TACBrJSONObject.Parse(RespostaHttp);
    try
      fpToken := js.AsString['access_token'];
      sec := js.AsInteger['expires_in'];
    finally
      js.Free;
    end;

   if (Trim(fpToken) = '') then
     DispararExcecao(EACBrPixHttpException.Create(ACBrStr(sErroAutenticacao)));

   fpValidadeToken := IncSecond(Now, sec);
   fpAutenticado := True;
  end
  else
    DispararExcecao(EACBrPixHttpException.CreateFmt( sErroHttp,
       [Http.ResultCode, ChttpMethodPOST, AURL]));
end;

procedure TACBrPSPBancoDoBrasil.SimularPagamentoPIX(
  const pixCopiaECola: String; var Code: Integer; var Texto: String);
var
  Body, AURL: String;
  RespostaHttp: AnsiString;
  ResultCode: Integer;
  js: TACBrJSONObject;
begin
  if (Trim(pixCopiaECola) = '') then
    raise EACBrPixException.CreateFmt(ACBrStr(sErroParametroInvalido), ['pixCopiaECola']);
    
  js := TACBrJSONObject.Create;
  try
    js.AddPair('pix', pixCopiaECola);
    Body := js.ToJSON;
  finally
    js.Free;
  end;

  PrepararHTTP;
  WriteStrToStream(Http.Document, Body);
  Http.MimeType := CContentTypeApplicationJSon;
  ConfigurarAutenticacao(ChttpMethodPOST, cBBEndPointPagarPix);
  AURL := cBBURLSandboxPagarPix + '?' + cBBParamAppKey + '=' + cBBKeySandboxPagarPix;

  TransmitirHttp(ChttpMethodPOST, AURL, ResultCode, RespostaHttp);
  if (ResultCode = HTTP_OK) then
  begin
    js := TACBrJSONObject.Parse(RespostaHttp);
    try
      code := js.AsInteger['code'];
      texto := js.AsString['texto'];
    finally
      js.Free;
    end;

    if (code <> 0) then
      DispararExcecao(EACBrPixHttpException.Create('Code: '+
        IntToStr(code) +' - '+ UTF8ToNativeString(texto)));
  end
  else
    DispararExcecao(EACBrPixHttpException.CreateFmt( sErroHttp,
       [Http.ResultCode, ChttpMethodPOST, AURL]));
end;

procedure TACBrPSPBancoDoBrasil.QuandoAcessarEndPoint(
  const AEndPoint: String; var AURL: String; var AMethod: String);
begin
  // BB n�o tem: POST /cob - Mudando para /PUT com "txid" vazio
  if (UpperCase(AMethod) = ChttpMethodPOST) then
    AMethod := ChttpMethodPUT;
end;

procedure TACBrPSPBancoDoBrasil.QuandoReceberRespostaEndPoint(const AEndPoint,
  AURL, AMethod: String; var AResultCode: Integer; var RespostaHttp: AnsiString);
begin
  // Banco do Brasil, responde OK a esse EndPoint, de forma diferente da especificada
  if (UpperCase(AMethod) = ChttpMethodPUT) and (AEndPoint = cEndPointCob) and (AResultCode = HTTP_OK) then
  begin
    AResultCode := HTTP_CREATED;

    // Ajuste no Json de Resposta em Testes alterando textoImagemQRcode p/ pixCopiaECola - Icozeira
    if (ACBrPixCD.Ambiente = ambTeste) then
      RespostaHttp := StringReplace(RespostaHttp, 'textoImagemQRcode', 'pixCopiaECola', [rfReplaceAll]);
  end;

  // Ajuste para o M�todo Patch do BB - Icozeira - 14/04/2022
  if (UpperCase(AMethod) = ChttpMethodPATCH) and (AEndPoint = cEndPointCob) and (AResultCode = HTTP_CREATED) then
    AResultCode := HTTP_OK;
end;

function TACBrPSPBancoDoBrasil.ObterURLAmbiente(const Ambiente: TACBrPixCDAmbiente): String;
begin
  if (Ambiente = ambProducao) then
    Result := cBBURLProducao
  else
    Result := cBBURLSandbox;

  Result := Result + cBBPathAPIPix;
end;

function TACBrPSPBancoDoBrasil.CalcularEndPointPath(const aMethod,
  aEndPoint: String): String;
begin
  Result := Trim(aEndPoint);

  // BB deve utilizar /cobqrcode em ambiente de homologa��o
  if ((UpperCase(aMethod) = ChttpMethodPOST) or
      (UpperCase(aMethod) = ChttpMethodPUT)) and
      (aEndPoint = cEndPointCob) and (ACBrPixCD.Ambiente = ambTeste) then
    Result := cBBEndPointCobHomologacao;

  // BB utiliza delimitador antes dos par�metros de query
  if (aEndPoint = cEndPointCob) then
    Result := URLComDelimitador(Result);
end;

procedure TACBrPSPBancoDoBrasil.ConfigurarQueryParameters(const Method, EndPoint: String);
begin
  inherited ConfigurarQueryParameters(Method, EndPoint);

  if (fDeveloperApplicationKey <> '') then
    URLQueryParams.Values[cBBParamDevAppKey] := fDeveloperApplicationKey;
end;

procedure TACBrPSPBancoDoBrasil.TratarRetornoComErro(ResultCode: Integer;
  const RespostaHttp: AnsiString; Problema: TACBrPIXProblema);
var
  js, ej: TACBrJSONObject;
  ae: TACBrJSONArray;
begin
  if (pos('"ocorrencia"', RespostaHttp) > 0) then   // Erro no formato pr�prio do B.B.
  begin
     (* Exemplo de Retorno
       {
	    "erros": [{
		    "codigo": "4769515",
		    "versao": "1",
		    "mensagem": "N�o h� informa��es para os dados informados.",
		    "ocorrencia": "CHOM00000062715498140101"
	    }]
       }
     *)

    js := TACBrJSONObject.Parse(RespostaHttp);
    try
      ae := js.AsJSONArray['erros'];
      if Assigned(ae) and (ae.Count > 0) then
      begin
        ej := ae.ItemAsJSONObject[0];
        Problema.title := ej.AsString['ocorrencia'];
        Problema.status := StrToIntDef(ej.AsString['codigo'], -1);
        Problema.detail := ej.AsString['mensagem'];
      end;
    finally
      js.Free;
    end;

    if (Problema.title = '') then
      AtribuirErroHTTPProblema(Problema);
  end
  else if  (pos('"statusCode"', RespostaHttp) > 0) then   // Erro interno
  begin
    // Exemplo de Retorno
    // {"statusCode":401,"error":"Unauthorized","message":"Bad Credentials","attributes":{"error":"Bad Credentials"}}

    js := TACBrJSONObject.Parse(RespostaHttp);
    try
      Problema.title := js.AsString['error'];
      Problema.status := js.AsInteger['statusCode'];
      Problema.detail := js.AsString['message'];
    finally
      js.Free;
    end;

    if (Problema.title = '') then
      AtribuirErroHTTPProblema(Problema);
  end
  else
    inherited TratarRetornoComErro(ResultCode, RespostaHttp, Problema);
end;

end.

