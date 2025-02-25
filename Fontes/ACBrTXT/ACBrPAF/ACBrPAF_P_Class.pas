{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Isaque Pinheiro                                 }
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

unit ACBrPAF_P_Class;

interface

uses SysUtils, Classes, DateUtils, ACBrTXTClass,
     ACBrPAF_P;

type
  /// TPAF_P -

  { TPAF_P }

  TPAF_P = class(TACBrTXTClass)
  private
    FRegistroP1: TRegistroP1;       /// FRegistroP1
    FRegistroP2: TRegistroP2List;   /// Lista de FRegistroP2
    FRegistroP9: TRegistroP9;       /// FRegistroP9

    procedure CriaRegistros;
    procedure LiberaRegistros;
  public
    constructor Create;/// Create
    destructor Destroy; override; /// Destroy
    procedure LimpaRegistros;

    procedure WriteRegistroP1;
    procedure WriteRegistroP2;
    procedure WriteRegistroP9;

    property RegistroP1: TRegistroP1 read FRegistroP1 write FRegistroP1;
    property RegistroP2: TRegistroP2List read FRegistroP2 write FRegistroP2;
    property RegistroP9: TRegistroP9 read FRegistroP9 write FRegistroP9;
  end;

implementation

uses ACBrTXTUtils;

{ TPAF_P }

constructor TPAF_P.Create;
begin
  inherited;
  CriaRegistros;
end;

procedure TPAF_P.CriaRegistros;
begin
  FRegistroP1 := TRegistroP1.Create;
  FRegistroP2 := TRegistroP2List.Create;
  FRegistroP9 := TRegistroP9.Create;

  FRegistroP9.TOT_REG := 0;
end;

destructor TPAF_P.Destroy;
begin
  LiberaRegistros;
  inherited;
end;

procedure TPAF_P.LiberaRegistros;
begin
  FRegistroP1.Free;
  FRegistroP2.Free;
  FRegistroP9.Free;
end;

procedure TPAF_P.LimpaRegistros;
begin
  /// Limpa os Registros
  LiberaRegistros;
  /// Recriar os Registros Limpos
  CriaRegistros;
end;

procedure TPAF_P.WriteRegistroP1;
begin
   if Assigned(FRegistroP1) then
   begin
      with FRegistroP1 do
      begin
        Check(funChecaCNPJ(CNPJ), '(P1) ESTABELECIMENTO: O CNPJ "%s" digitado � inv�lido!', [CNPJ]);
        Check(funChecaIE(IE, UF), '(P1) ESTABELECIMENTO: A Inscri��o Estadual "%s" digitada � inv�lida!', [IE]);
        ///
        Add( LFill('P1') +
             LFill(CNPJ, 14) +
             RFill(IE, 14) +
             RFill(IM, 14) +
             RFill(RAZAOSOCIAL, 50 ,ifThen(not InclusaoExclusao, ' ', '?')) );
      end;
   end;
end;

function OrdenarP2(AProd1, AProd2: Pointer): Integer;
begin
  Result := AnsiCompareText(
    TRegistroP2(AProd1).COD_MERC_SERV,
    TRegistroP2(AProd2).COD_MERC_SERV
  );
end;

procedure TPAF_P.WriteRegistroP2;
var
intFor: integer;
begin
  if Assigned(FRegistroP2) then
  begin
     FRegistroP2.Sort(@OrdenarP2);

     Check(funChecaCNPJ(FRegistroP1.CNPJ), '(P2) ESTOQUE: O CNPJ "%s" digitado � inv�lido!', [FRegistroP1.CNPJ]);
     Check(Trim(FRegistroP1.CNPJ)<>EmptyStr, '(P1) N�o tem CNPJ');

     for intFor := 0 to FRegistroP2.Count - 1 do
     begin
        with FRegistroP2.Items[intFor] do
        begin
          ///
          Add( LFill('P2') +
               LFill(FRegistroP1.CNPJ, 14) +
               RFill(COD_MERC_SERV, 14) +
               RFill(CEST, 7) +
               RFill(NCM, 8) +
               RFill(DESC_MERC_SERV, 50) +
               RFill(UN_MED, 6, ifThen(RegistroValido, ' ', '?')) +
               RFill(IAT, 1) +
               RFill(IPPT, 1) +
               RFill(ST, 1) +
               LFill(ALIQ, 4) +
               LFill(VL_UNIT, 12, 2) );
        end;
        ///
        FRegistroP9.TOT_REG := FRegistroP9.TOT_REG + 1;
     end;
  end;
end;

procedure TPAF_P.WriteRegistroP9;
begin
   if Assigned(FRegistroP9) then
   begin
      with FRegistroP9 do
      begin
        Check(funChecaCNPJ(FRegistroP1.CNPJ),            '(P9) TOTALIZA��O: O CNPJ "%s" digitado � inv�lido!', [FRegistroP1.CNPJ]);
        Check(funChecaIE(FRegistroP1.IE, FRegistroP1.UF), '(P9) TOTALIZA��O: A Inscri��o Estadual "%s" digitada � inv�lida!', [FRegistroP1.IE]);
        ///
        Add( LFill('P9') +
             LFill(FRegistroP1.CNPJ, 14) +
             RFill(FRegistroP1.IE, 14) +
             LFill(TOT_REG, 6, 0) ) ;
      end;
   end;
end;

end.
