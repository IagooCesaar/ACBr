{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
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

unit SSInformatica.GravarXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrNFSeXGravarXml_ABRASFv2;

type
  { TNFSeW_SSInformatica203 }

  TNFSeW_SSInformatica203 = class(TNFSeW_ABRASFv2)
  protected
    procedure Configuracao; override;

  end;

implementation

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     SSInformatica
//==============================================================================

{ TNFSeW_SSInformatica203 }

procedure TNFSeW_SSInformatica203.Configuracao;
begin
  inherited Configuracao;

  // Propriedades de Formata��o de informa��es
  // elas requerem que seja declarado em uses a unit: ACBrXmlBase
  {
  FormatoEmissao     := tcDat;
  FormatoCompetencia := tcDat;

  FormatoAliq := tcDe4;
  }

  // elas requerem que seja declarado em uses a unit: ACBrNFSeXConversao
  {
  // filsComFormatacao, filsSemFormatacao, filsComFormatacaoSemZeroEsquerda
  FormatoItemListaServico := filsComFormatacao;
  }
  (*
  DivAliq100  := False;

  NrMinExigISS := 1;
  NrMaxExigISS := 1;

  GerarTagServicos := True;

  // Gera ou n�o o atributo ID no grupo <Rps> da vers�o 2 do layout da ABRASF.
  GerarIDRps := False;
  // Gera ou n�o o NameSpace no grupo <Rps> da vers�o 2 do layout da ABRASF.
  GerarNSRps := True;

  GerarIDDeclaracao := True;
  GerarEnderecoExterior := False;

  TagTomador := 'Tomador';
  TagIntermediario := 'Intermediario';

  // Numero de Ocorrencias Minimas de uma tag
  // se for  0 s� gera a tag se o conteudo for diferente de vazio ou zero
  // se for  1 sempre vai gerar a tag
  // se for -1 nunca gera a tag

  // Por padr�o as tags abaixo s�o opcionais
  NrOcorrRazaoSocialInterm := 0;
  NrOcorrValorDeducoes := 0;
  NrOcorrRegimeEspecialTributacao := 0;
  NrOcorrValorISS := 0;
  NrOcorrAliquota := 0;
  NrOcorrDescIncond := 0;
  NrOcorrDescCond := 0;
  NrOcorrMunIncid := 0;
  NrOcorrInscEstInter := 0;
  NrOcorrOutrasRet := 0;
  NrOcorrCodigoCNAE := 0;
  NrOcorrEndereco := 0;
  NrOcorrCodigoPaisTomador := 0;
  NrOcorrUFTomador := 0;
  NrOcorrCepTomador := 0;
  NrOcorrCodTribMun_1 := 0;
  NrOcorrNumProcesso := 0;
  NrOcorrInscMunTomador := 0;
  NrOcorrCodigoPaisServico := 0;
  NrOcorrRespRetencao := 0;

  // Por padr�o as tags abaixo s�o obrigat�rias
  NrOcorrIssRetido := 1;
  NrOcorrOptanteSimplesNacional := 1;
  NrOcorrIncentCultural := 1;
  NrOcorrItemListaServico := 1;
  NrOcorrCompetencia := 1;
  NrOcorrSerieRPS := 1;
  NrOcorrTipoRPS := 1;
  NrOcorrDiscriminacao_1 := 1;
  NrOcorrExigibilidadeISS := 1;
  NrOcorrCodigoMunic_1 := 1;

  // Por padr�o as tags abaixo n�o devem ser geradas
  NrOcorrCodTribMun_2 := -1;
  NrOcorrDiscriminacao_2 := -1;
  NrOcorrNaturezaOperacao := -1;
  NrOcorrIdCidade := -1;
  NrOcorrValorTotalRecebido := -1;
  NrOcorrInscEstTomador := -1;
  NrOcorrOutrasInformacoes := -1;
  NrOcorrTipoNota := -1;
  NrOcorrSiglaUF := -1;
  NrOcorrEspDoc := -1;
  NrOcorrSerieTal := -1;
  NrOcorrFormaPag := -1;
  NrOcorrNumParcelas := -1;
  NrOcorrBaseCalcCRS := -1;
  NrOcorrIrrfInd := -1;
  NrOcorrRazaoSocialPrest := -1;
  NrOcorrPercCargaTrib := -1;
  NrOcorrValorCargaTrib := -1;
  NrOcorrPercCargaTribMun := -1;
  NrOcorrValorCargaTribMun := -1;
  NrOcorrPercCargaTribEst := -1;
  NrOcorrValorCargaTribEst := -1;
  NrOcorrInformacoesComplemetares := -1;
  NrOcorrValTotTrib := -1;
  NrOcorrTipoLogradouro := -1;
  NrOcorrLogradouro := -1;
  NrOcorrDDD := -1;
  NrOcorrTipoTelefone := -1;
  NrOcorrProducao := -1;
  NrOcorrAtualizaTomador := -1;
  NrOcorrTomadorExterior := -1;
  NrOcorrCodigoMunic_2 := -1;
  NrOcorrNIFTomador := -1;
  NrOcorrID := -1;
  NrOcorrToken := -1;
  NrOcorrSenha := -1;
  NrOcorrFraseSecreta := -1;
  NrOcorrAliquotaPis := -1;
  NrOcorrRetidoPis := -1;
  NrOcorrAliquotaCofins := -1;
  NrOcorrRetidoCofins := -1;
  NrOcorrAliquotaInss := -1;
  NrOcorrRetidoInss := -1;
  NrOcorrAliquotaIr := -1;
  NrOcorrRetidoIr := -1;
  NrOcorrAliquotaCsll := -1;
  NrOcorrRetidoCsll := -1;
  *)
end;

end.
