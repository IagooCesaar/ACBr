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
  https://developers.sicoob.com.br

*)

{$I ACBr.inc}
unit ACBrPIXPSPSicoob;

interface

uses
  Classes, SysUtils,
  ACBrPIXCD, ACBrOpenSSLUtils;

const
  cSicoobURLSandbox      = 'https://api.sicoob.com.br';
  cSicoobURLProducao     = 'https://api.sicoob.com.br';
  cSicoobURLAuth         = 'https://auth.sicoob.com.br';
  cSicoobPathAuthToken   = '/auth/realms/cooperado/protocol/openid-connect/token';
  cSicoobPathAPIPix      = '/pix/api/v2';
  cSicoobURLAuthTeste    = cSicoobURLAuth+cSicoobPathAuthToken;
  cSicoobURLAuthProducao = cSicoobURLAuth+cSicoobPathAuthToken;

type

  { TACBrPSPSicoob }

  TACBrPSPSicoob = class(TACBrPSP)
  private
    fSandboxStatusCode: String;
    fxCorrelationID: String;
    fArquivoCertificado: String;
    fArquivoChavePrivada: String;
    fQuandoNecessitarCredenciais: TACBrQuandoNecessitarCredencial;

    procedure SetArquivoCertificado(AValue: String);
    procedure SetArquivoChavePrivada(AValue: String);
    procedure QuandoReceberRespostaEndPoint(const AEndPoint, AURL, AMethod: String;
      var AResultCode: Integer; var RespostaHttp: AnsiString);
  protected
    function ObterURLAmbiente(const Ambiente: TACBrPixCDAmbiente): String; override;
    procedure ConfigurarQueryParameters(const Method, EndPoint: String); override;
    procedure ConfigurarHeaders(const Method, AURL: String); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Clear; override;
    procedure Autenticar; override;

  published
    property APIVersion;
    property ClientID;
    property ClientSecret;

    property ArquivoChavePrivada: String read fArquivoChavePrivada write SetArquivoChavePrivada;
    property ArquivoCertificado: String read fArquivoCertificado write SetArquivoCertificado;
    property SandboxStatusCode: String read fSandboxStatusCode write fSandboxStatusCode;

    property QuandoNecessitarCredenciais: TACBrQuandoNecessitarCredencial
      read fQuandoNecessitarCredenciais write fQuandoNecessitarCredenciais;
  end;

implementation

uses
  synautil, synacode, ACBrJSON,
  ACBrUtil.Strings,
  ACBrUtil.Base,
  DateUtils;

{ TACBrPSPSicoob }

constructor TACBrPSPSicoob.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fpQuandoReceberRespostaEndPoint := QuandoReceberRespostaEndPoint;
  Clear;
end;

procedure TACBrPSPSicoob.Clear;
begin
  inherited Clear;
  fxCorrelationID := '';
  fSandboxStatusCode := '';
  fArquivoCertificado := '';
  fArquivoChavePrivada := '';
  fQuandoNecessitarCredenciais := Nil;
end;

procedure TACBrPSPSicoob.Autenticar;
var
  AURL, Body, BasicAutentication: String;
  RespostaHttp: AnsiString;
  ResultCode, sec: Integer;
  js: TACBrJSONObject;
  qp: TACBrQueryParams;
begin
  LimparHTTP;

  if (ACBrPixCD.Ambiente = ambProducao) then
    AURL := cSicoobURLAuthProducao
  else
    AURL := cSicoobURLAuthTeste;


  qp := TACBrQueryParams.Create;
  try
    qp.Values['grant_type'] := 'client_credentials';
    qp.Values['client_id'] := ClientID;
    qp.Values['scope'] := 'cob.read cob.write pix.read pix.write';
    Body := qp.AsURL;
    WriteStrToStream(Http.Document, Body);
    Http.MimeType := CContentTypeApplicationWwwFormUrlEncoded;
  finally
    qp.Free;
  end;

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
      [Http.ResultCode, ChttpMethodGET, AURL]));
end;

procedure TACBrPSPSicoob.SetArquivoCertificado(AValue: String);
begin
  if (fArquivoCertificado = AValue) then
    Exit;

  fArquivoCertificado := Trim(AValue);
end;

procedure TACBrPSPSicoob.SetArquivoChavePrivada(AValue: String);
begin
  if (fArquivoChavePrivada = AValue) then
    Exit;

  fArquivoChavePrivada := (AValue);
end;

procedure TACBrPSPSicoob.QuandoReceberRespostaEndPoint(const AEndPoint, AURL,
  AMethod: String; var AResultCode: Integer; var RespostaHttp: AnsiString);
begin
  // Sicoob responde OK a esse EndPoint, de forma diferente da especificada
  if (UpperCase(AMethod) = ChttpMethodPUT) and (AEndPoint = cEndPointPix) and (AResultCode = HTTP_OK) then
    AResultCode := HTTP_CREATED;
end;

function TACBrPSPSicoob.ObterURLAmbiente(const Ambiente: TACBrPixCDAmbiente): String;
begin
  if (Ambiente = ambProducao) then
    Result := cSicoobURLProducao
  else
    Result := cSicoobURLSandbox;

  Result := Result + cSicoobPathAPIPix;
end;

procedure TACBrPSPSicoob.ConfigurarHeaders(const Method, AURL: String);
begin
  inherited ConfigurarHeaders(Method, AURL);

  if NaoEstaVazio(fArquivoCertificado) then
    Http.Sock.SSL.CertificateFile := fArquivoCertificado;
  if NaoEstaVazio(fArquivoChavePrivada) then
    Http.Sock.SSL.PrivateKeyFile  := fArquivoChavePrivada;

  if NaoEstaVazio(ClientID) then
    Http.Headers.Add('client_id: ' + ClientID);
end;

procedure TACBrPSPSicoob.ConfigurarQueryParameters(const Method, EndPoint: String);
begin
  if NaoEstaVazio(fSandboxStatusCode) then
    URLQueryParams.Values['status_code'] := fSandboxStatusCode;
end;

end.
