unit Discord;

interface

uses
  Classes, SysUtils, System.Net.HttpClient, System.json;

const
  DS_CHANNEL = 'channel';
  DS_USERNAME = 'username';
  DS_AVATAR_URL = 'avatar_url';
  DS_CONTENT = 'content';
  DS_EMBEDS = 'embeds';
  DS_EMBEDS_AUTORH = 'author';
  DS_EMBEDS_AUTHOR_NAME = 'name';
  DS_EMBEDS_AUTHOR_URL = 'url';
  DS_EMBEDS_AUTHOR_ICONURL = 'icon_url';
  DS_EMBEDS_TITLE = 'title';
  DS_EMBEDS_URL = 'url';
  DS_EMBEDS_DESCRIPTION = 'description';
  DS_EMBEDS_COLOR = 'color';
  DS_EMBEDS_FIELDS = 'fields';
  DS_EMBEDS_FIELDS_NAME = 'name';
  DS_EMBEDS_FIELDS_VALUE = 'value';
  DS_EMBEDS_FIELDS_inline = 'inline';
  DS_EMBEDS_THUMBNAIL = 'thumbnail';
  DS_EMBEDS_THUMBNAIL_URL = 'url';
  DS_EMBEDS_IMAGE = 'image';
  DS_EMBEDS_IMAGE_URL = 'url';
  DS_EMBEDS_FOOTER = 'footer';
  DS_EMBEDS_FOOTER_TEXT = 'text';
  DS_EMBEDS_FOOTER_ICONURL = 'icon_url';

type

  { TDiscordEmbedsFooter }

  TDiscordEmbedsFooter = class
  private
    FIconUrl: string;
    FObject: TJSONObject;
    FText: string;
    procedure SetIconUrl(AValue: string);
    procedure SetText(AValue: string);
  public
    constructor Create;
    destructor Destroy; override;
    function GetObject: TJSONObject;
    property Text: string read FText write SetText;
    property IconUrl: string read FIconUrl write SetIconUrl;
  end;


  { TDiscrodEmbedsThumbNail }

  TDiscrodEmbedsThumbNail = class
  private
    FObject: TJSONObject;
    FUrl: string;
    procedure SetUrl(AValue: string);
  public
    constructor Create;
    destructor Destroy; override;
    property URL: string read FUrl write SetUrl;
    function GetObject: TJSONObject;
  end;

  { TDiscrodEmbedsImage }

  TDiscrodEmbedsImage = TDiscrodEmbedsThumbNail;

  { TDiscrodEmbedsAuthor }

  TDiscrodEmbedsAuthor = class
  private
    FIconUrl: string;
    FObject: TJSONObject;
    FName: string;
    FUrl: string;
    procedure SetIconUrl(AValue: string);
    procedure SetName(AValue: string);
    procedure SetUrl(AValue: string);
  public
    constructor Create;
    destructor Destroy; override;
    property Name: string read FName write SetName;
    property URL: string read FUrl write SetUrl;
    property IconUrl: string read FIconUrl write SetIconUrl;
    function GetObject: TJSONObject;
  end;


  { TDiscordEmbedsField }

  TDiscordEmbedsField = class
  private
    FObject: TJSONObject;
    FName: string;
    FValue: string;
    FInline: boolean;
    procedure SetInline(AValue: boolean);
    procedure SetName(AValue: string);
    procedure SetValue(AValue: string);
  public
    constructor Create;
    destructor Destroy; override;
    property Name: string read FName write SetName;
    property Value: string read FValue write SetValue;
    property mInline: boolean read FInline write SetInline;
    function GetObject: TJSONObject;
  end;

  { TDiscordEmbeds }

  TDiscordEmbeds = class
  private
    FObject: TJSONObject;
    FFieldsArray: TJSONArray;
    FTitle: string;
    FURL: string;
    FDescription: string;
    FColor: integer;
    procedure SetColor(AValue: integer);
    procedure SetDescription(AValue: string);
    procedure SetTitle(AValue: string);
    procedure SetUrl(AValue: string);
    procedure AddRec(ARecName: string; AJSONData: TJSONValue);
    function GetObject: TJSONObject;
  public
    constructor Create;
    destructor Destroy; override;
    property Title: string read FTitle write SetTitle;
    property URL: string read FURL write SetUrl;
    property Description: string read FDescription write SetDescription;
    property Color: integer read FColor write SetColor;
    procedure AddField(ADiscrodEmbedsField: TDiscordEmbedsField);
    procedure SetAuthor(ADiscrodEmbedsAuthor: TDiscrodEmbedsAuthor);
    procedure SetThumbNail(ADiscordEmbedsThumbNail: TDiscrodEmbedsThumbNail);
    procedure SetImage(ADiscordEmbedsImage: TDiscrodEmbedsImage);
    procedure SetFooter(ADiscordEmbedsFooter: TDiscordEmbedsFooter);
  end;

  { TDiscordMessage }

  TDiscordMessage = class
  private
    FWebhookUrl: string;
    FIconURL: string;
    FContent: string;
    FUserName: string;
    FChannel: string;
    FObject: TJSONObject;
    FEmbedsArray: TJSONArray;
    function GetJSONMessage: string;
    procedure SetChannel(AValue: string);
    procedure SetIconURL(AValue: string);
    procedure SetContent(AValue: string);
    procedure SetUserName(AValue: string);
    procedure AddRec(ARecName: string; AJSONArray: TJSONArray);
  public
    constructor Create(AWebhookURL: string);
    destructor Destroy; override;
    function SendMessage: boolean;
    procedure AddEmbeds(AEmbeds: TDiscordEmbeds);
    property UserName: string read FUserName write SetUserName;
    property JSONMessage: string read GetJSONMessage;
    property Content: string read FContent write SetContent;
    property AvatarURL: string read FIconURL write SetIconURL;
    property Channel: string read FChannel write SetChannel;
  end;

implementation

{ TDiscordEmbedsFooter }

procedure TDiscordEmbedsFooter.SetIconUrl(AValue: string);
begin
  if FIconUrl = AValue then
    Exit;
  FIconUrl := AValue;
  FObject.AddPair(DS_EMBEDS_FOOTER_ICONURL, FIconUrl);
end;

procedure TDiscordEmbedsFooter.SetText(AValue: string);
begin
  if FText = AValue then
    Exit;
  FText := AValue;
  FObject.AddPair(DS_EMBEDS_FOOTER_TEXT, FText);
end;

constructor TDiscordEmbedsFooter.Create;
begin
  FObject := TJSONObject.Create;
end;

destructor TDiscordEmbedsFooter.Destroy;
begin
  inherited Destroy;
end;

function TDiscordEmbedsFooter.GetObject: TJSONObject;
begin
  Result := FObject;
end;

{ TDiscrodEmbedsThumbNail }

procedure TDiscrodEmbedsThumbNail.SetUrl(AValue: string);
begin
  if FUrl = AValue then
    Exit;
  FUrl := AValue;
  FObject.AddPair(DS_EMBEDS_THUMBNAIL_URL, FUrl);
end;

constructor TDiscrodEmbedsThumbNail.Create;
begin
  FObject := TJSONObject.Create;
end;

destructor TDiscrodEmbedsThumbNail.Destroy;
begin
  inherited Destroy;
end;

function TDiscrodEmbedsThumbNail.GetObject: TJSONObject;
begin
  Result := FObject;
end;

{ TDiscrodEmbedsAuthor }

procedure TDiscrodEmbedsAuthor.SetIconUrl(AValue: string);
begin
  if FIconUrl = AValue then
    Exit;
  FIconUrl := AValue;
  FObject.AddPair(DS_EMBEDS_AUTHOR_ICONURL, FIconUrl);
end;

procedure TDiscrodEmbedsAuthor.SetName(AValue: string);
begin
  if FName = AValue then
    Exit;
  FName := AValue;
  FObject.AddPair(DS_EMBEDS_AUTHOR_NAME, FName);
end;

procedure TDiscrodEmbedsAuthor.SetUrl(AValue: string);
begin
  if FUrl = AValue then
    Exit;
  FUrl := AValue;
  FObject.AddPair(DS_EMBEDS_AUTHOR_URL, FUrl);
end;

constructor TDiscrodEmbedsAuthor.Create;
begin
  FObject := TJSONObject.Create;
end;

destructor TDiscrodEmbedsAuthor.Destroy;
begin
  inherited Destroy;
end;

function TDiscrodEmbedsAuthor.GetObject: TJSONObject;
begin
  Result := FObject;
end;

{ TDiscordEmbeds }

procedure TDiscordEmbeds.SetColor(AValue: integer);
begin
  if FColor = AValue then
    Exit;
  FColor := AValue;
  FObject.AddPair(DS_EMBEDS_COLOR, TJSONNumber.Create(FColor));
end;

procedure TDiscordEmbeds.SetDescription(AValue: string);
begin
  if FDescription = AValue then
    Exit;
  FDescription := AValue;
  FObject.AddPair(DS_EMBEDS_DESCRIPTION, FDescription);
end;

procedure TDiscordEmbeds.SetTitle(AValue: string);
begin
  if FTitle = AValue then
    Exit;
  FTitle := AValue;
  FObject.AddPair(DS_EMBEDS_TITLE, FTitle);
end;

procedure TDiscordEmbeds.SetUrl(AValue: string);
begin
  if FURL = AValue then
    Exit;
  FURL := AValue;
  FObject.AddPair(DS_EMBEDS_URL, FURL);
end;

procedure TDiscordEmbeds.AddRec(ARecName: string; AJSONData: TJSONValue);
var
  dat: TJSONValue;
begin
  if FObject.TryGetValue(ARecName, dat) then
    dat := AJSONData
  else
    FObject.AddPair(ARecName, AJSONData);
end;

function TDiscordEmbeds.GetObject: TJSONObject;
begin
  Result := FObject;
end;

constructor TDiscordEmbeds.Create;
begin
  FObject := TJSONObject.Create;
end;

destructor TDiscordEmbeds.Destroy;
begin
  inherited Destroy;
end;

procedure TDiscordEmbeds.AddField(ADiscrodEmbedsField: TDiscordEmbedsField);
begin
  if not Assigned(FFieldsArray) then
  begin
    FFieldsArray := TJSONArray.Create;
    AddRec(DS_EMBEDS_FIELDS, FFieldsArray);
  end;

  FFieldsArray.Add(ADiscrodEmbedsField.GetObject);
end;

procedure TDiscordEmbeds.SetAuthor(ADiscrodEmbedsAuthor: TDiscrodEmbedsAuthor);
begin
  FObject.AddPair(DS_EMBEDS_AUTORH, ADiscrodEmbedsAuthor.GetObject);
end;

procedure TDiscordEmbeds.SetThumbNail(ADiscordEmbedsThumbNail: TDiscrodEmbedsThumbNail);
begin
  FObject.AddPair(DS_EMBEDS_THUMBNAIL, ADiscordEmbedsThumbNail.GetObject);
end;

procedure TDiscordEmbeds.SetImage(ADiscordEmbedsImage: TDiscrodEmbedsImage);
begin
  FObject.AddPair(DS_EMBEDS_IMAGE, ADiscordEmbedsImage.GetObject);
end;

procedure TDiscordEmbeds.SetFooter(ADiscordEmbedsFooter: TDiscordEmbedsFooter);
begin
  FObject.AddPair(DS_EMBEDS_FOOTER, ADiscordEmbedsFooter.GetObject);
end;

{ TDiscordEmbedsField }

procedure TDiscordEmbedsField.SetInline(AValue: boolean);
begin
  if FInline = AValue then
    Exit;
  FInline := AValue;
  FObject.AddPair(DS_EMBEDS_FIELDS_inline, TJSONBool.Create(FInline));
end;

procedure TDiscordEmbedsField.SetName(AValue: string);
begin
  if FName = AValue then
    Exit;
  FName := AValue;
  FObject.AddPair(DS_EMBEDS_FIELDS_NAME, FName);
end;

procedure TDiscordEmbedsField.SetValue(AValue: string);
begin
  if FValue = AValue then
    Exit;
  FValue := AValue;
  FObject.AddPair(DS_EMBEDS_FIELDS_VALUE, FValue);
end;

constructor TDiscordEmbedsField.Create;
begin
  FObject := TJSONObject.Create;
end;

destructor TDiscordEmbedsField.Destroy;
begin
  inherited Destroy;
end;

function TDiscordEmbedsField.GetObject: TJSONObject;
begin
  Result := FObject;
end;

{ TDiscordMessage }

function TDiscordMessage.GetJSONMessage: string;
begin
  Result := FObject.ToJSON;
  //Result := FObject.FormatJSON;
end;

procedure TDiscordMessage.SetChannel(AValue: string);
begin
  if FChannel = AValue then
    Exit;
  FChannel := AValue;
  FObject.AddPair(DS_CHANNEL, AValue);
end;

procedure TDiscordMessage.SetIconURL(AValue: string);
begin
  if FIconURL = AValue then
    Exit;
  FIconURL := AValue;
  FObject.AddPair(DS_AVATAR_URL, AValue);
end;

procedure TDiscordMessage.SetContent(AValue: string);
begin
  if FContent = AValue then
    Exit;
  FContent := AValue;
  FObject.AddPair(DS_CONTENT, AValue);
end;

procedure TDiscordMessage.SetUserName(AValue: string);
begin
  if FUserName = AValue then
    Exit;
  FUserName := AValue;

  FObject.AddPair(DS_USERNAME, AValue);
end;

procedure TDiscordMessage.AddRec(ARecName: string; AJSONArray: TJSONArray);
var
  dat: TJSONArray;
begin
  if FObject.TryGetValue(ARecName, dat) then
    dat := AJSONArray
  else
    FObject.AddPair(ARecName, AJSONArray);
end;

constructor TDiscordMessage.Create(AWebhookURL: string);
begin
  FWebhookUrl := AWebhookURL;
  FObject := TJSONObject.Create;
end;

destructor TDiscordMessage.Destroy;
begin
  FreeAndNil(FObject);

  inherited Destroy;
end;

function TDiscordMessage.SendMessage: boolean;
var
  bodyJson, Response: string;
  http: THTTPClient;
  Params: TStringStream;
  res: boolean;
  Data: TStringList;
begin
  bodyJson := JSONMessage;
  http := THTTPClient.Create;
  http.ContentType := 'application/json';

  Params := TStringStream.Create(bodyJson);
  with http.Post(FWebhookUrl, Params) do
  begin
    res := StatusCode = 200;
    Response := '';
    Data := TStringList.Create;
    try
      if res then
      begin
        Data.LoadFromStream(ContentStream);
        Response := Data.Text;
      end;
    finally
      FreeAndNil(Data);
      FreeAndNil(http);
    end;
  end;
  FreeAndNil(Params);

  Result := res;
end;

procedure TDiscordMessage.AddEmbeds(AEmbeds: TDiscordEmbeds);
begin
  if not Assigned(FEmbedsArray) then
  begin
    FEmbedsArray := TJSONArray.Create;
    AddRec(DS_EMBEDS, FEmbedsArray);
  end;

  FEmbedsArray.Add(AEmbeds.GetObject);
end;

end.

