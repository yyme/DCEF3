unit main;

interface

{$I cef.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ActnList, Menus, ComCtrls, ExtCtrls, XPMan,
  ceflib, cefvcl;

type
  TMainForm = class(TForm)
    ActionDevTool: TAction;
    ActionDoc: TAction;
    ActionDom: TAction;
    ActionExecuteJS: TAction;
    ActionFileScheme: TAction;
    ActionGetSource: TAction;
    ActionGetText: TAction;
    ActionGoTo: TAction;
    ActionGroup: TAction;
    ActionHome: TAction;
    ActionList: TActionList;
    ActionNext: TAction;
    ActionPrev: TAction;
    ActionPrint: TAction;
    ActionReload: TAction;
    ActionZoomIn: TAction;
    ActionZoomOut: TAction;
    ActionZoomReset: TAction;
    ButtonGoto: TSpeedButton;
    ButtonHome: TSpeedButton;
    ButtonNext: TSpeedButton;
    ButtonPrev: TSpeedButton;
    ButtonReload: TSpeedButton;
    Chromium: TChromium;
    DevTools: TChromiumDevTools;
    EditAddress: TEdit;
    MainMenu: TMainMenu;
    MenuItemDevelopperTools: TMenuItem;
    MenuItemDocumentation: TMenuItem;
    MenuItemExecuteJavaScript: TMenuItem;
    MenuItemExit: TMenuItem;
    MenuItemFile: TMenuItem;
    MenuItemFileScheme: TMenuItem;
    MenuItemGetSource: TMenuItem;
    MenuItemGetText: TMenuItem;
    MenuItemGoogleGroup: TMenuItem;
    MenuItemHelp: TMenuItem;
    MenuItemPrint: TMenuItem;
    MenuItemTest: TMenuItem;
    MenuItemVisitDOM: TMenuItem;
    MenuItemZoomIn: TMenuItem;
    MenuItemZoomOut: TMenuItem;
    MenuItemZoomReset: TMenuItem;
    PanelControl: TPanel;
    SaveDialog: TSaveDialog;
    Splitter: TSplitter;
    StatusBar: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ActionDevToolExecute(Sender: TObject);
    procedure ActionDocExecute(Sender: TObject);
    procedure ActionDomExecute(Sender: TObject);
    procedure ActionExecuteJSExecute(Sender: TObject);
    procedure ActionFileSchemeExecute(Sender: TObject);
    procedure ActionGetSourceExecute(Sender: TObject);
    procedure ActionGetTextExecute(Sender: TObject);
    procedure ActionGoToExecute(Sender: TObject);
    procedure ActionGroupExecute(Sender: TObject);
    procedure ActionHomeExecute(Sender: TObject);
    procedure ActionHomeUpdate(Sender: TObject);
    procedure ActionNextExecute(Sender: TObject);
    procedure ActionNextUpdate(Sender: TObject);
    procedure ActionPrevExecute(Sender: TObject);
    procedure ActionPrevUpdate(Sender: TObject);
    procedure ActionPrintExecute(Sender: TObject);
    procedure ActionReloadExecute(Sender: TObject);
    procedure ActionReloadUpdate(Sender: TObject);
    procedure ActionZoomInExecute(Sender: TObject);
    procedure ActionZoomOutExecute(Sender: TObject);
    procedure ActionZoomResetExecute(Sender: TObject);
    procedure ChromiumAddressChange(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; const url: ustring);
    procedure ChromiumBeforeContextMenu(Sender: TObject;
      const browser: ICefBrowser; const frame: ICefFrame;
      const params: ICefContextMenuParams; const model: ICefMenuModel);
    procedure ChromiumBeforeDownload(Sender: TObject;
      const browser: ICefBrowser; const downloadItem: ICefDownloadItem;
      const suggestedName: ustring; const callback: ICefBeforeDownloadCallback);
    procedure ChromiumBeforePopup(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; const targetUrl, targetFrameName: ustring;
      var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
      var client: ICefClient; var settings: TCefBrowserSettings;
      var noJavascriptAccess: Boolean; out Result: Boolean);
    procedure ChromiumBeforeResourceLoad(Sender: TObject;
      const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; out Result: Boolean);
    procedure ChromiumCertificateError(Sender: TObject; certError: Integer;
      const requestUrl: ustring;
      const callback: ICefAllowCertificateErrorCallback; out Result: Boolean);
    procedure ChromiumContextMenuCommand(Sender: TObject;
      const browser: ICefBrowser; const frame: ICefFrame;
      const params: ICefContextMenuParams; commandId: Integer;
      eventFlags: TCefEventFlags; out Result: Boolean);
    procedure ChromiumDownloadUpdated(Sender: TObject;
      const browser: ICefBrowser; const downloadItem: ICefDownloadItem;
      const callback: ICefDownloadItemCallback);
    procedure ChromiumLoadEnd(Sender: TObject;
      const browser: ICefBrowser; const frame: ICefFrame; httpStatusCode: Integer);
    procedure ChromiumLoadStart(Sender: TObject;
      const browser: ICefBrowser; const frame: ICefFrame);
    procedure ChromiumProcessMessageReceived(Sender: TObject;
      const browser: ICefBrowser; sourceProcess: TCefProcessId;
      const message: ICefProcessMessage; out Result: Boolean);
    procedure ChromiumStatusMessage(Sender: TObject;
      const browser: ICefBrowser; const value: ustring);
    procedure ChromiumTitleChange(Sender: TObject;
      const browser: ICefBrowser; const title: ustring);
    procedure EditAddressKeyPress(Sender: TObject; var Key: Char);
    procedure MenuItemExitClick(Sender: TObject);
  private
    FLoading: Boolean;
    function IsMain(const b: ICefBrowser; const f: ICefFrame = nil): Boolean;
  end;

  TCustomRenderProcessHandler = class(TCefRenderProcessHandlerOwn)
  protected
    procedure OnWebKitInitialized; override;
    function OnProcessMessageReceived(const browser: ICefBrowser; sourceProcess: TCefProcessId;
      const message: ICefProcessMessage): Boolean; override;
  end;

  TTestExtension = class
    class function hello: string;
  end;

var
  MainForm: TMainForm;

implementation

uses
  Registry;

const
  CUSTOMMENUCOMMAND_INSPECTELEMENT = 7241221;

{$R *.dfm}

{ TMainForm }

procedure TMainForm.ActionDevToolExecute(Sender: TObject);
begin
  if TAction(Sender).Checked then
  begin
    DevTools.Visible := True;
    Splitter.Visible := True;
    DevTools.ShowDevTools(Chromium.Browser);
  end else
  begin
    DevTools.CloseDevTools(Chromium.Browser);
    Splitter.Visible := False;
    DevTools.Visible := False;
  end;
end;

procedure TMainForm.ActionDocExecute(Sender: TObject);
begin
  Chromium.Load('http://magpcss.org/ceforum/apidocs3');
end;

procedure TMainForm.ActionDomExecute(Sender: TObject);
begin
  Chromium.browser.SendProcessMessage(PID_RENDERER,
    TCefProcessMessageRef.New('visitdom'));
end;

procedure TMainForm.ActionExecuteJSExecute(Sender: TObject);
begin
  if Chromium.Browser <> nil then
    Chromium.Browser.MainFrame.ExecuteJavaScript(
      'alert(''JavaScript execute works!'');', 'about:blank', 0);
end;

procedure TMainForm.ActionFileSchemeExecute(Sender: TObject);
begin
  if Chromium.Browser <> nil then
    Chromium.Browser.MainFrame.LoadUrl('local://c/');
end;

procedure CallbackGetSource(const src: ustring);
var
  source: ustring;
begin
  source := src;
  source := StringReplace(source, '<', '&lt;', [rfReplaceAll]);
  source := StringReplace(source, '>', '&gt;', [rfReplaceAll]);
  source := '<html><body>Source:<pre>' + source + '</pre></body></html>';
  MainForm.Chromium.Browser.MainFrame.LoadString(source, 'source://html');
end;

procedure TMainForm.ActionGetSourceExecute(Sender: TObject);
begin
  Chromium.Browser.MainFrame.GetSourceProc(CallbackGetSource);
end;

procedure CallbackGetText(const txt: ustring);
var
  source: ustring;
begin
  source := txt;
  source := StringReplace(source, '<', '&lt;', [rfReplaceAll]);
  source := StringReplace(source, '>', '&gt;', [rfReplaceAll]);
  source := '<html><body>Text:<pre>' + source + '</pre></body></html>';
  MainForm.Chromium.Browser.MainFrame.LoadString(source, 'source://text');
end;

procedure TMainForm.ActionGetTextExecute(Sender: TObject);
begin
  Chromium.Browser.MainFrame.GetTextProc(CallbackGetText);
end;

procedure TMainForm.ActionGoToExecute(Sender: TObject);
begin
  if Chromium.Browser <> nil then
    Chromium.Browser.MainFrame.LoadUrl(EditAddress.Text);
end;

procedure TMainForm.ActionGroupExecute(Sender: TObject);
begin
  Chromium.Load('https://groups.google.com/forum/?fromgroups#!forum/delphichromiumembedded');
end;

procedure TMainForm.ActionHomeExecute(Sender: TObject);
begin
  if Chromium.Browser <> nil then
    Chromium.Browser.MainFrame.LoadUrl(Chromium.DefaultUrl);
end;

procedure TMainForm.ActionHomeUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := Chromium.Browser <> nil;
end;

procedure TMainForm.ActionNextExecute(Sender: TObject);
begin
  if Chromium.Browser <> nil then
    Chromium.Browser.GoForward;
end;

procedure TMainForm.ActionNextUpdate(Sender: TObject);
begin
  if Chromium.Browser <> nil then
    TAction(Sender).Enabled := Chromium.Browser.CanGoForward
  else
    TAction(Sender).Enabled := False;
end;

procedure TMainForm.ActionPrevExecute(Sender: TObject);
begin
  if Chromium.Browser <> nil then
    Chromium.Browser.GoBack;
end;

procedure TMainForm.ActionPrevUpdate(Sender: TObject);
begin
  if Chromium.Browser <> nil then
    TAction(Sender).Enabled := Chromium.Browser.CanGoBack
  else
    TAction(Sender).Enabled := False;
end;

procedure TMainForm.ActionPrintExecute(Sender: TObject);
begin
  Chromium.Browser.Host.Print;
end;

procedure TMainForm.ActionReloadExecute(Sender: TObject);
begin
  if Chromium.Browser <> nil then
    if FLoading then
      Chromium.Browser.StopLoad else
      Chromium.Browser.Reload;
end;

procedure TMainForm.ActionReloadUpdate(Sender: TObject);
begin
  if FLoading then
    TAction(sender).Caption := 'X' else
    TAction(sender).Caption := 'R';
  TAction(Sender).Enabled := Chromium.Browser <> nil;
end;

function TMainForm.IsMain(const b: ICefBrowser; const f: ICefFrame): Boolean;
begin
  Result := (b <> nil) and (b.Identifier = Chromium.BrowserId) and ((f = nil) or (f.IsMain));
end;

procedure TMainForm.ActionZoomInExecute(Sender: TObject);
begin
  if Chromium.Browser <> nil then
    Chromium.Browser.Host.ZoomLevel := Chromium.Browser.Host.ZoomLevel + 0.5;
end;

procedure TMainForm.ActionZoomOutExecute(Sender: TObject);
begin
  if Chromium.Browser <> nil then
    Chromium.Browser.Host.ZoomLevel := Chromium.Browser.Host.ZoomLevel - 0.5;
end;

procedure TMainForm.ActionZoomResetExecute(Sender: TObject);
begin
  if Chromium.Browser <> nil then
    Chromium.Browser.Host.ZoomLevel := 0;
end;

procedure TMainForm.ChromiumAddressChange(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame; const url: ustring);
begin
  if IsMain(browser, frame) then
    EditAddress.Text := url;
end;

procedure TMainForm.ChromiumBeforeContextMenu(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const params: ICefContextMenuParams; const model: ICefMenuModel);
begin
  model.AddItem(CUSTOMMENUCOMMAND_INSPECTELEMENT, 'Inspect Element');
end;

procedure TMainForm.ChromiumBeforeDownload(Sender: TObject;
  const browser: ICefBrowser; const downloadItem: ICefDownloadItem;
  const suggestedName: ustring; const callback: ICefBeforeDownloadCallback);
begin
  callback.Cont(ExtractFilePath(ParamStr(0)) + suggestedName, True);
end;

procedure TMainForm.ChromiumBeforePopup(Sender: TObject; const browser: ICefBrowser;
  const frame: ICefFrame; const targetUrl, targetFrameName: ustring;
  var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
  var client: ICefClient; var settings: TCefBrowserSettings;
  var noJavascriptAccess: Boolean; out Result: Boolean);
begin
  // prevent popup
  Chromium.Load(targetUrl);
  Result := True;
end;

procedure TMainForm.ChromiumBeforeResourceLoad(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const request: ICefRequest; out Result: Boolean);
var
  u: TUrlParts;
begin
  // redirect home to google
  if CefParseUrl(request.Url, u) then
    if (u.host = 'home') then
    begin
      u.host := 'www.google.com';
      request.Url := CefCreateUrl(u);
    end;
end;

procedure TMainForm.ChromiumCertificateError(Sender: TObject; certError: Integer;
  const requestUrl: ustring; const callback: ICefAllowCertificateErrorCallback;
  out Result: Boolean);
begin
  // let use untrusted certificates (ex: cacert.org)
  callback.Cont(True);
  Result := True;
end;

procedure TMainForm.ChromiumContextMenuCommand(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const params: ICefContextMenuParams; commandId: Integer;
  eventFlags: TCefEventFlags; out Result: Boolean);
var
  mousePoint: TCefPoint;
begin
  Result := False;
  if (commandId = CUSTOMMENUCOMMAND_INSPECTELEMENT) then
  begin
    mousePoint.x := params.XCoord;
    mousePoint.y := params.YCoord;
    Splitter.Visible := True;
    DevTools.Visible := True;
    ActionDevTool.Checked := True;
    DevTools.CloseDevTools(Chromium.Browser);
    Application.ProcessMessages;
    DevTools.ShowDevTools(Chromium.Browser, @mousePoint);
    Result := True;
  end;
end;

procedure TMainForm.ChromiumDownloadUpdated(Sender: TObject;
  const browser: ICefBrowser; const downloadItem: ICefDownloadItem;
  const callback: ICefDownloadItemCallback);
begin
  if downloadItem.IsInProgress then
    StatusBar.SimpleText := IntToStr(downloadItem.PercentComplete) + '%' else
    StatusBar.SimpleText := '';
end;

procedure TMainForm.ChromiumLoadEnd(Sender: TObject; const browser: ICefBrowser;
  const frame: ICefFrame; httpStatusCode: Integer);
begin
  if IsMain(browser, frame) then
    FLoading := False;
end;

procedure TMainForm.ChromiumLoadStart(Sender: TObject; const browser: ICefBrowser;
  const frame: ICefFrame);
begin
  if IsMain(browser, frame) then
    FLoading := True;
end;

procedure TMainForm.ChromiumProcessMessageReceived(Sender: TObject;
  const browser: ICefBrowser; sourceProcess: TCefProcessId;
  const message: ICefProcessMessage; out Result: Boolean);
begin
  if (message.Name = 'mouseover') then
  begin
    StatusBar.SimpleText := message.ArgumentList.GetString(0);
    Result := True;
  end else
    Result := False;
end;

procedure TMainForm.ChromiumStatusMessage(Sender: TObject;
  const browser: ICefBrowser; const value: ustring);
begin
  StatusBar.SimpleText := value
end;

procedure TMainForm.ChromiumTitleChange(Sender: TObject; const browser: ICefBrowser;
  const title: ustring);
begin
  if IsMain(browser) then
    Caption := title;
end;

procedure TMainForm.EditAddressKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    if Chromium.Browser <> nil then
    begin
      Chromium.Browser.MainFrame.LoadUrl(EditAddress.Text);
      Abort;
    end;
  end;
end;

procedure TMainForm.MenuItemExitClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // avoid AV when closing application
  if CefSingleProcess then
    Chromium.Load('about:blank');
  CanClose := True;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FLoading := False;
end;

{ TCustomRenderProcessHandler }


function getpath(const n: ICefDomNode): string;
begin
  Result := '<' + n.Name + '>';
  if (n.Parent <> nil) then
    Result := getpath(n.Parent) + Result;
end;

function TCustomRenderProcessHandler.OnProcessMessageReceived(
  const browser: ICefBrowser; sourceProcess: TCefProcessId;
  const message: ICefProcessMessage): Boolean;
begin
//{$IFDEF DELPHI14_UP}
//  if (message.Name = 'visitdom') then
//    begin
//      browser.MainFrame.VisitDomProc(
//        procedure(const doc: ICefDomDocument) begin
//          doc.Body.AddEventListenerProc('mouseover', True,
//            procedure (const event: ICefDomEvent)
//            var
//              msg: ICefProcessMessage;
//            begin
//              msg := TCefProcessMessageRef.New('mouseover');
//              msg.ArgumentList.SetString(0, getpath(event.Target));
//              browser.SendProcessMessage(PID_BROWSER, msg);
//            end)
//        end);
//        Result := True;
//    end
//  else
//{$ENDIF}
    Result := False;
end;

procedure TCustomRenderProcessHandler.OnWebKitInitialized;
begin
{$IFDEF DELPHI14_UP}
  TCefRTTIExtension.Register('app', TTestExtension);
{$ENDIF}
end;

{ TTestExtension }

class function TTestExtension.hello: string;
begin
  Result := 'Hello from Delphi';
end;

initialization
  CefRemoteDebuggingPort := 9000;
  CefRenderProcessHandler := TCustomRenderProcessHandler.Create;
  CefBrowserProcessHandler := TCefBrowserProcessHandlerOwn.Create;
end.
