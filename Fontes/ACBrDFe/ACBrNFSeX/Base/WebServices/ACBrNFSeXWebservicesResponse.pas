{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2021 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Rafael Dias                                     }
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

unit ACBrNFSeXWebservicesResponse;

interface

uses
  {$IF DEFINED(NEXTGEN)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IFEND}
  ACBrBase,
  ACBrNFSeXClass, ACBrNFSeXConversao, ACBrNFSeXWebserviceBase;

type
  TNFSeEventoCollectionItem = class
  private
    FCodigo: string;
    FDescricao: string;
    FCorrecao: string;
  public
    property Codigo: string read FCodigo write FCodigo;
    property Descricao: string read FDescricao write FDescricao;
    property Correcao: string read FCorrecao write FCorrecao;
  end;

  TNFSeEventoCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TNFSeEventoCollectionItem;
    procedure SetItem(Index: Integer; Value: TNFSeEventoCollectionItem);
  public
    function New: TNFSeEventoCollectionItem;
    function Add(ANota: TNFSeEventoCollectionItem): Integer; reintroduce;
    Procedure Insert(Index: Integer; ANota: TNFSeEventoCollectionItem); reintroduce;

    property Items[Index: Integer]: TNFSeEventoCollectionItem read GetItem write SetItem; default;
  end;

  TNFSeResumoCollectionItem = class
  private
    FNumeroNota: string;
    FCodigoVerificacao: string;
    FNumeroRps: string;
    FSerieRps: string;
    FSituacao: string;
    FDescSituacao: string;
    FLink: string;
    FProtocolo: string;
    FSerieNota: string;
    FData: TDateTime;
  public
    property NumeroNota: string read FNumeroNota write FNumeroNota;
    property CodigoVerificacao: string read FCodigoVerificacao write FCodigoVerificacao;
    property NumeroRps: string read FNumeroRps write FNumeroRps;
    property SerieRps: string read FSerieRps write FSerieRps;
    property Situacao: string read FSituacao write FSituacao;
    property DescSituacao: string read FDescSituacao write FDescSituacao;
    property Link: string read FLink write FLink;
    property Protocolo: string read FProtocolo write FProtocolo;
    property SerieNota: string read FSerieNota write FSerieNota;
    property Data: TDateTime read FData write FData;
  end;

  TNFSeResumoCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TNFSeResumoCollectionItem;
    procedure SetItem(Index: Integer; Value: TNFSeResumoCollectionItem);
  public
    function New: TNFSeResumoCollectionItem;
    function Add(ANota: TNFSeResumoCollectionItem): Integer; reintroduce;
    Procedure Insert(Index: Integer; ANota: TNFSeResumoCollectionItem); reintroduce;

    property Items[Index: Integer]: TNFSeResumoCollectionItem read GetItem write SetItem; default;
  end;

  TNotasCanceladasCollectionItem = class
  private
    FNumeroNota: string;
    FCodigoVerficacao: string;
    FInscricaoMunicipalPrestador: string;
  public
    property NumeroNota: string read FNumeroNota write FNumeroNota;
    property CodigoVerficacao: string read FCodigoVerficacao write FCodigoVerficacao;
    property InscricaoMunicipalPrestador: string read FInscricaoMunicipalPrestador write FInscricaoMunicipalPrestador;
  end;

  TNotasCanceladasCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TNotasCanceladasCollectionItem;
    procedure SetItem(Index: Integer; Value: TNotasCanceladasCollectionItem);
  public
    function New: TNotasCanceladasCollectionItem; reintroduce;
    function Add(ANota: TNotasCanceladasCollectionItem): Integer; reintroduce;
    Procedure Insert(Index: Integer; ANota: TNotasCanceladasCollectionItem); reintroduce;

    property Items[Index: Integer]: TNotasCanceladasCollectionItem read GetItem write SetItem; default;
  end;

  TRetCancelamento = class
  private
    FNumeroLote: string;
    FSituacao: string;
    FDataHora: TDateTime;
    FMsgCanc: string;
    FSucesso: string;
    FLink: string;
    FNumeroNota: string;
    FPedido: TPedidocancelamento;
    FNotasCanceladas: TNotasCanceladasCollection;
  public
    constructor Create;
    destructor Destroy; override;

    property NumeroLote: string read FNumeroLote write FNumeroLote;
    property Situacao: string read FSituacao write FSituacao;
    property DataHora: TDateTime read FDataHora write FDataHora;
    property MsgCanc: string read FMsgCanc write FMsgCanc;
    property Sucesso: string read FSucesso write FSucesso;
    property Link: string read FLink write FLink;
    property NumeroNota: string read FNumeroNota  write FNumeroNota;
    property Pedido: TPedidocancelamento read FPedido;
    property NotasCanceladas: TNotasCanceladasCollection read FNotasCanceladas;
  end;

  TNFSeParamsResponse = class
  private
    FXml: string;
    FTagEnvio: string;
    FPrefixo: string;
    FPrefixo2: string;
    FNameSpace: string;
    FNameSpace2: string;
    FIdAttr: string;
    FVersao: string;
    FSerie: string;
    FMotivo: string;
    FCodVerif: string;
  public
    procedure Clear;

    property Xml: string read FXml write FXml;
    property TagEnvio: string read FTagEnvio write FTagEnvio;
    property Prefixo: string read FPrefixo write FPrefixo;
    property Prefixo2: string read FPrefixo2 write FPrefixo2;
    property NameSpace: string read FNameSpace write FNameSpace;
    property NameSpace2: string read FNameSpace2 write FNameSpace2;
    property IdAttr: string read FIdAttr write FIdAttr;
    property Versao: string read FVersao write FVersao;
    property Serie: string read FSerie write FSerie;
    property Motivo: string read FMotivo write FMotivo;
    property CodVerif: string read FCodVerif write FCodVerif;
  end;

  TNFSeWebserviceResponse = class
  private
    FSituacao: string;
    FDescSituacao: string;
    FLote: string;
    FSucesso: Boolean;
    FNumeroNota: string;
    FSerieNota: string;
    FData: TDateTime;
    FDataCanc: TDateTime;
    FidNota: string;
    FLink: string;
    FProtocolo: string;
    FNumeroRps: string;
    FSerieRps: string;
    FCodVerif: string;

    FAlertas: TNFSeEventoCollection;
    FErros: TNFSeEventoCollection;
    FResumos: TNFSeResumoCollection;

    FEnvelopeEnvio: string;
    FEnvelopeRetorno: string;
    FArquivoEnvio: string;
    FArquivoRetorno: string;

    function GetXmlEnvio: string;
    procedure SetXmlEnvio(const Value: string);
    function GetXmlRetorno: string;
    procedure SetXmlRetorno(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear; virtual;

    property Situacao: string read FSituacao write FSituacao;
    property DescSituacao: string read FDescSituacao write FDescSituacao;
    property Lote: string read FLote write FLote;
    property Sucesso: Boolean read FSucesso write FSucesso;
    property NumeroNota: string read FNumeroNota write FNumeroNota;
    property SerieNota: string read FSerieNota write FSerieNota;
    property Data: TDateTime read FData write FData;
    property DataCanc: TDateTime read FDataCanc write FDataCanc;
    property idNota: string read FidNota write FidNota;
    property Link: string read FLink write FLink;
    property Protocolo: string read FProtocolo write FProtocolo;
    property NumeroRps: string read FNumeroRps write FNumeroRps;
    property SerieRps: string read FSerieRps write FSerieRps;
    property CodVerif: string read FCodVerif write FCodVerif;

    property Alertas: TNFSeEventoCollection read FAlertas;
    property Erros: TNFSeEventoCollection read FErros;
    property Resumos: TNFSeResumoCollection read FResumos;

    property XmlEnvio: string read GetXmlEnvio write SetXmlEnvio;
    property XmlRetorno: string read GetXmlRetorno write SetXmlRetorno;

    property EnvelopeEnvio: string read FEnvelopeEnvio write FEnvelopeEnvio;
    property EnvelopeRetorno: string read FEnvelopeRetorno write FEnvelopeRetorno;
    property ArquivoEnvio: string read FArquivoEnvio write FArquivoEnvio;
    property ArquivoRetorno: string read FArquivoRetorno write FArquivoRetorno;
  end;

  TNFSeEmiteResponse = class(TNFSeWebserviceResponse)
  private
    FMaxRps: Integer;
    FModoEnvio: TmodoEnvio;
    FCodVerificacao: string;
    FNomeArq: string;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear; override;

    property MaxRps: Integer read FMaxRps write FMaxRps;
    property ModoEnvio: TmodoEnvio read FModoEnvio write FModoEnvio;
    property CodVerificacao: string read FCodVerificacao write FCodVerificacao;
    property NomeArq: string read FNomeArq write FNomeArq;
  end;

  TNFSeConsultaSituacaoResponse = class(TNFSeWebserviceResponse)
  private

  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear; override;
  end;

  TNFSeCancelamento = class
  private
    FDataHora: TDateTime;
    FMotivo: string;

    function GetCancelada: Boolean;
  public
    property Cancelada: Boolean read GetCancelada;
    property DataHora: TDateTime read FDataHora write FDataHora;
    property Motivo: string read FMotivo write FMotivo;
  end;

  TNFSeConsultaLoteRpsResponse = class(TNFSeWebserviceResponse)
  private
    FCodVerificacao: string;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear; override;

    property CodVerificacao: string read FCodVerificacao write FCodVerificacao;
  end;

  TNFSeConsultaNFSeporRpsResponse = class(TNFSeWebserviceResponse)
  private
    FNumRPS: string;
    FSerie: string;
    FTipo: string;
    FCodVerificacao: string;
    FCancelamento: TNFSeCancelamento;
    FNumNotaSubstituidora: string;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear; override;

    property NumRPS: string read FNumRPS write FNumRPS;
    property Serie: string read FSerie write FSerie;
    property Tipo: string read FTipo write FTipo;
    property CodVerificacao: string read FCodVerificacao write FCodVerificacao;
    property Cancelamento: TNFSeCancelamento read FCancelamento write FCancelamento;
    property NumNotaSubstituidora: string read FNumNotaSubstituidora write FNumNotaSubstituidora;
  end;

  TNFSeConsultaNFSeResponse = class(TNFSeWebserviceResponse)
  private
    FMetodo: TMetodo;
    FInfConsultaNFSe: TInfConsultaNFSe;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear; override;

    property Metodo: TMetodo read FMetodo write FMetodo;
    property InfConsultaNFSe: TInfConsultaNFSe read FInfConsultaNFSe write FInfConsultaNFSe;
  end;

  TNFSeCancelaNFSeResponse = class(TNFSeWebserviceResponse)
  private
    FCodVerificacao: string;
    FInfCancelamento: TInfCancelamento;
    FRetCancelamento: TRetCancelamento;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear; override;

    property CodVerificacao: string read FCodVerificacao write FCodVerificacao;
    property InfCancelamento: TInfCancelamento read FInfCancelamento write FInfCancelamento;
    property RetCancelamento: TRetCancelamento read FRetCancelamento;
  end;

  TNFSeSubstituiNFSeResponse = class(TNFSeCancelaNFSeResponse)
  private
    FNumRPS: string;
    FSerie: string;
    FTipo: string;
    FCodVerificacao: string;
    FPedCanc: string;
    FNumNotaSubstituida: string;
    FNumNotaSubstituidora: string;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear; override;

    property NumRPS: string read FNumRPS write FNumRPS;
    property Serie: string read FSerie write FSerie;
    property Tipo: string read FTipo write FTipo;
    property CodVerificacao: string read FCodVerificacao write FCodVerificacao;
    property PedCanc: string read FPedCanc write FPedCanc;
    property NumNotaSubstituida: string read FNumNotaSubstituida write FNumNotaSubstituida;
    property NumNotaSubstituidora: string read FNumNotaSubstituidora write FNumNotaSubstituidora;
  end;

  TNFSeGerarTokenResponse = class(TNFSeWebserviceResponse)
  private
    FToken: string;
    FDataExpiracao: TDateTime;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear; override;

    property Token: string read FToken write FToken;
    property DataExpiracao: TDateTime read FDataExpiracao write FDataExpiracao;
  end;

  TNFSeAbreSessaoResponse = class(TNFSeWebserviceResponse)
  private
    FHashIdent: string;
  public
    property HashIdent: string read FHashIdent write FHashIdent;
  end;

  TNFSeFechaSessaoResponse = class(TNFSeWebserviceResponse)
  private
    FHashIdent: string;
  public
    property HashIdent: string read FHashIdent write FHashIdent;
  end;

  TNFSeEnviarEventoResponse = class(TNFSeWebserviceResponse)
  private
    FToken: string;
    FDataExpiracao: TDateTime;
    FInfEvento: TInfEvento;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear; override;

    property Token: string read FToken write FToken;
    property DataExpiracao: TDateTime read FDataExpiracao write FDataExpiracao;
    property InfEvento: TInfEvento read FInfEvento write FInfEvento;
  end;

implementation

uses
  SysUtils;

{ TNFSeEventoCollection }

function TNFSeEventoCollection.GetItem(Index: Integer): TNFSeEventoCollectionItem;
begin
  Result := TNFSeEventoCollectionItem(inherited Items[Index]);
end;

procedure TNFSeEventoCollection.SetItem(Index: Integer; Value: TNFSeEventoCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TNFSeEventoCollection.New: TNFSeEventoCollectionItem;
begin
  Result := TNFSeEventoCollectionItem.Create;
  Self.Add(Result);
end;

function TNFSeEventoCollection.Add(ANota: TNFSeEventoCollectionItem): Integer;
begin
  Result := inherited Add(ANota);
end;

Procedure TNFSeEventoCollection.Insert(Index: Integer; ANota: TNFSeEventoCollectionItem);
begin
  inherited Insert(Index, ANota);
end;

{ TNotasCanceladasCollection }

function TNotasCanceladasCollection.GetItem(Index: Integer): TNotasCanceladasCollectionItem;
begin
  Result := TNotasCanceladasCollectionItem(inherited Items[Index]);
end;

procedure TNotasCanceladasCollection.SetItem(Index: Integer; Value: TNotasCanceladasCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TNotasCanceladasCollection.New: TNotasCanceladasCollectionItem;
begin
  Result := TNotasCanceladasCollectionItem.Create;
  Self.Add(Result);
end;

function TNotasCanceladasCollection.Add(ANota: TNotasCanceladasCollectionItem): Integer;
begin
  Result := inherited Add(ANota);
end;

Procedure TNotasCanceladasCollection.Insert(Index: Integer; ANota: TNotasCanceladasCollectionItem);
begin
  inherited Insert(Index, ANota);
end;

{ TRetCancelamento }

constructor TRetCancelamento.Create;
begin
  inherited Create;

  FPedido := TPedidoCancelamento.Create;
  FNotasCanceladas := TNotasCanceladasCollection.Create;
end;

destructor TRetCancelamento.Destroy;
begin
  FPedido.Free;
  FNotasCanceladas.Free;

  inherited Destroy;
end;

{ TNFSeWebserviceResponse }

procedure TNFSeWebserviceResponse.Clear;
var
  i: Integer;
begin
  Situacao := '';
  DescSituacao := '';
  Lote := '';
  Sucesso := False;
  NumeroNota := '';
  SerieNota := '';
  Data := 0;
  idNota := '';
  Link := '';
  Protocolo := '';
  NumeroRps := '';
  SerieRps := '';

  if Assigned(FErros) then
  begin
    for i := FErros.Count - 1 downto 0 do
      FErros.Delete(i);
  end;

  if Assigned(FAlertas) then
  begin
    for i := FAlertas.Count - 1 downto 0 do
      FAlertas.Delete(i);
  end;

  if Assigned(FResumos) then
  begin
    for i := FResumos.Count - 1 downto 0 do
      FResumos.Delete(i);
  end;

  XmlEnvio := '';
  XmlRetorno := '';
  EnvelopeEnvio := '';
  EnvelopeRetorno := '';
  ArquivoEnvio := '';
  ArquivoRetorno := '';
end;

constructor TNFSeWebserviceResponse.Create;
begin
  inherited Create;

  FSucesso := False;
  FAlertas := TNFSeEventoCollection.Create;
  FErros := TNFSeEventoCollection.Create;
  FResumos := TNFSeResumoCollection.Create;
end;

destructor TNFSeWebserviceResponse.Destroy;
begin
  FAlertas.Free;
  FErros.Free;
  FResumos.Free;

  inherited;
end;

function TNFSeWebserviceResponse.GetXmlEnvio: string;
begin
  Result := ArquivoEnvio;
end;

function TNFSeWebserviceResponse.GetXmlRetorno: string;
begin
  Result := ArquivoRetorno;
end;

procedure TNFSeWebserviceResponse.SetXmlEnvio(const Value: string);
begin
  ArquivoEnvio := Value;
end;

procedure TNFSeWebserviceResponse.SetXmlRetorno(const Value: string);
begin
  ArquivoRetorno := Value;
end;

{ TNFSeConsultaNFSeResponse }

constructor TNFSeConsultaNFSeResponse.Create;
begin
  inherited Create;

  Clear;
end;

procedure TNFSeConsultaNFSeResponse.Clear;
begin
  inherited Clear;

  if Assigned(FInfConsultaNFSe) then
    FInfConsultaNFSe.Free;

  FMetodo := tmConsultarNFSe;

  FInfConsultaNFSe := TInfConsultaNFSe.Create;
end;

destructor TNFSeConsultaNFSeResponse.Destroy;
begin
  FInfConsultaNFSe.Free;

  inherited Destroy;
end;

{ TNFSeCancelaNFSeResponse }

constructor TNFSeCancelaNFSeResponse.Create;
begin
  inherited Create;
  FInfCancelamento := nil;
  FRetCancelamento := nil;

  Clear;
end;

procedure TNFSeCancelaNFSeResponse.Clear;
begin
  inherited Clear;

  if Assigned(FInfCancelamento) then
    FreeAndNil(FInfCancelamento);

  if Assigned(FRetCancelamento) then
   FreeAndNil(FRetCancelamento);

  FInfCancelamento := TInfCancelamento.Create;
  FRetCancelamento := TRetCancelamento.Create;
end;

destructor TNFSeCancelaNFSeResponse.Destroy;
begin
  if Assigned(FInfCancelamento) then
    FreeAndNil(FInfCancelamento);

  if Assigned(FRetCancelamento) then
    FreeAndNil(FRetCancelamento);

  inherited Destroy;
end;

{ TNFSeSubstituiNFSeResponse }

procedure TNFSeSubstituiNFSeResponse.Clear;
begin
  inherited Clear;

end;

constructor TNFSeSubstituiNFSeResponse.Create;
begin
  inherited Create;

end;

destructor TNFSeSubstituiNFSeResponse.Destroy;
begin

  inherited Destroy;
end;

{ TNFSeEmiteResponse }

procedure TNFSeEmiteResponse.Clear;
begin
  inherited Clear;

  MaxRps := 0;
  ModoEnvio := meLoteAssincrono;
  CodVerificacao := '';
  NomeArq := '';
end;

constructor TNFSeEmiteResponse.Create;
begin
  inherited Create;

end;

destructor TNFSeEmiteResponse.Destroy;
begin

  inherited Destroy;
end;

{ TNFSeConsultaSituacaoResponse }

procedure TNFSeConsultaSituacaoResponse.Clear;
begin
  inherited Clear;

  Lote := '';
  Situacao := '';
  Protocolo := '';
end;

constructor TNFSeConsultaSituacaoResponse.Create;
begin
  inherited Create;

end;

destructor TNFSeConsultaSituacaoResponse.Destroy;
begin

  inherited Destroy;
end;

{ TNFSeConsultaLoteRpsResponse }

procedure TNFSeConsultaLoteRpsResponse.Clear;
begin
  inherited Clear;

  Lote := '';
  Protocolo := '';
  Situacao := '';
  CodVerificacao := '';
end;

constructor TNFSeConsultaLoteRpsResponse.Create;
begin
  inherited Create;

  Clear;
end;

destructor TNFSeConsultaLoteRpsResponse.Destroy;
begin

  inherited Destroy;
end;

{ TNFSeConsultaNFSeporRpsResponse }

procedure TNFSeConsultaNFSeporRpsResponse.Clear;
begin
  inherited Clear;

  NumRPS := '';
  Serie := '';
  Tipo := '';
  CodVerificacao := '';
  NumNotaSubstituidora := '';

  if Assigned(FCancelamento) then
    FCancelamento.Free;

  FCancelamento := TNFSeCancelamento.Create;
end;

constructor TNFSeConsultaNFSeporRpsResponse.Create;
begin
  inherited Create;

  FCancelamento := TNFSeCancelamento.Create;
end;

destructor TNFSeConsultaNFSeporRpsResponse.Destroy;
begin
  if Assigned(FCancelamento) then
    FCancelamento.Free;

  inherited Destroy;
end;

{ TNFSeParamsResponse }

procedure TNFSeParamsResponse.Clear;
begin
  Xml := '';
  TagEnvio := '';
  Prefixo := '';
  Prefixo2 := '';
  NameSpace := '';
  NameSpace2 := '';
  IdAttr := '';
  Versao := '';
  Serie := '';
  Motivo := '';
  CodVerif := '';
end;

{ TNFSeCancelamento }

function TNFSeCancelamento.GetCancelada: Boolean;
begin
  Result := ((FDataHora > 0) and (Trim(FMotivo) <> ''));
end;

{ TNFSeGerarTokenResponse }

procedure TNFSeGerarTokenResponse.Clear;
begin
  inherited Clear;

  Token := '';
  DataExpiracao := 0;
end;

constructor TNFSeGerarTokenResponse.Create;
begin
  inherited Create;

end;

destructor TNFSeGerarTokenResponse.Destroy;
begin

  inherited Destroy;
end;

{ TNFSeResumoCollection }

function TNFSeResumoCollection.Add(ANota: TNFSeResumoCollectionItem): Integer;
begin
  Result := inherited Add(ANota);
end;

function TNFSeResumoCollection.GetItem(
  Index: Integer): TNFSeResumoCollectionItem;
begin
  Result := TNFSeResumoCollectionItem(inherited Items[Index]);
end;

procedure TNFSeResumoCollection.Insert(Index: Integer;
  ANota: TNFSeResumoCollectionItem);
begin
  inherited Insert(Index, ANota);
end;

function TNFSeResumoCollection.New: TNFSeResumoCollectionItem;
begin
  Result := TNFSeResumoCollectionItem.Create;
  Self.Add(Result);
end;

procedure TNFSeResumoCollection.SetItem(Index: Integer;
  Value: TNFSeResumoCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TNFSeEnviarEventoResponse }

procedure TNFSeEnviarEventoResponse.Clear;
begin
  inherited Clear;

  Token := '';
  DataExpiracao := 0;
end;

constructor TNFSeEnviarEventoResponse.Create;
begin
  inherited Create;

  FInfEvento := TInfEvento.Create;
end;

destructor TNFSeEnviarEventoResponse.Destroy;
begin
  FInfEvento.Free;

  inherited Destroy;
end;

end.
