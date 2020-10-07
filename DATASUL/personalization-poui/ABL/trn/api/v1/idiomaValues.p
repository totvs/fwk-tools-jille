{utp/ut-api.i}

{utp/ut-api-action.i pGetDataById GET /byid/~* }
{utp/ut-api-action.i pGetAll GET /~* }

{utp/ut-api-action.i pValidateForm POST /validateForm/~* }
{utp/ut-api-action.i pCreate POST /~* }

{utp/ut-api-action.i pUpdate PUT /~* }

{utp/ut-api-action.i pDelete DELETE /~* }

{utp/ut-api-notfound.i}

{btb/personalizationUtil.i}

DEFINE VARIABLE oRequest   AS JsonAPIRequestParser NO-UNDO.
DEFINE VARIABLE oResponse  AS JsonAPIResponse      NO-UNDO.
DEFINE VARIABLE oObj       AS JsonObject           NO-UNDO.
DEFINE VARIABLE oList      AS JsonArray            NO-UNDO.
DEFINE VARIABLE oBody      AS JsonObject           NO-UNDO. 

DEFINE VARIABLE cId        AS CHARACTER            NO-UNDO.
DEFINE VARIABLE cProg      AS CHARACTER            NO-UNDO.
DEFINE VARIABLE cList      AS CHARACTER            NO-UNDO.
DEFINE VARIABLE cTypeList  AS CHARACTER            NO-UNDO.
DEFINE VARIABLE cFld       AS CHARACTER            NO-UNDO.
DEFINE VARIABLE cType      AS CHARACTER            NO-UNDO.
DEFINE VARIABLE ix         AS INTEGER              NO-UNDO.
DEFINE VARIABLE hTab       AS HANDLE               NO-UNDO.
DEFINE VARIABLE hQry       AS HANDLE               NO-UNDO.
DEFINE VARIABLE hPers      AS HANDLE               NO-UNDO.
DEFINE VARIABLE rTab       AS RECID                NO-UNDO.

/** Procedure que retorna os valores **/
PROCEDURE pGetDataById:
    DEFINE INPUT  PARAMETER oJsonInput  AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER oJsonOutput AS JsonObject NO-UNDO.

    oObj = NEW JsonObject().

    // Le os parametros enviados pela interface HTML
    oRequest = NEW JsonAPIRequestParser(oJsonInput).
    
    // Obtem o programa e o codigo do registro corrente
    cProg = oRequest:getPathParams():getCharacter(2) NO-ERROR.
    cId = oRequest:getPathParams():getCharacter(3) NO-ERROR.

    LOG-MANAGER:WRITE-MESSAGE("pGetDataById - cProg = " + cProg, ">>>>>").
    LOG-MANAGER:WRITE-MESSAGE("pGetDataById - cId = " + cId, ">>>>>").

    // retorna a lista de campos a serem personalizados
    EMPTY TEMP-TABLE ttPersonalization.
    RUN btb/personalizationUtil.p PERSISTENT SET hPers.
    RUN piGetTTPersonalization IN hPers (cProg, OUTPUT table ttPersonalization).
    DELETE PROCEDURE hPers NO-ERROR.

    // se houver algum campo personalizado, busca as informacoes
    FIND FIRST ttPersonalization NO-LOCK NO-ERROR.
    IF  AVAILABLE ttPersonalization THEN DO:
        FIND idioma
            WHERE RECID(idioma) = integer(cId) 
            NO-LOCK NO-ERROR.
        IF  AVAILABLE idioma THEN DO:
            oObj:add("id", RECID(idioma)).

            // deve somente alimentar os campos que serao personalizados
            hTab = BUFFER idioma:HANDLE.
            FOR EACH ttPersonalization:    
                ASSIGN cFld = ttPersonalization.cod_campo_perzdo.
                oObj:add(cFld, hTab:BUFFER-FIELD(cFld):buffer-value()) NO-ERROR.
            END.
            hTab:BUFFER-RELEASE().
            DELETE OBJECT hTab NO-ERROR.
        END.
        LOG-MANAGER:WRITE-MESSAGE("pGetDataById - oObj = " + String(oObj:getJsonText()), ">>>>>").
    END.

    oResponse   = NEW JsonAPIResponse(oObj).
    oJsonOutput = oResponse:createJsonResponse().
END PROCEDURE.

/** Procedure que retorna os valores **/
PROCEDURE pGetAll:
    DEFINE INPUT  PARAMETER oJsonInput  AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER oJsonOutput AS JsonObject NO-UNDO.

    oList = NEW JsonArray().

    // Le os parametros enviados pela interface HTML
    oRequest = NEW JsonAPIRequestParser(oJsonInput).
    
    // Obtem o programa e o codigo do registro corrente
    cProg = oRequest:getPathParams():getCharacter(1) NO-ERROR.

    LOG-MANAGER:WRITE-MESSAGE("pGetAll - cProg = " + cProg, ">>>>>").

    // retorna a lista de campos a serem personalizados
    EMPTY TEMP-TABLE ttPersonalization.
    RUN btb/personalizationUtil.p PERSISTENT SET hPers.
    RUN piGetTTPersonalization IN hPers (cProg, OUTPUT table ttPersonalization).
    DELETE PROCEDURE hPers NO-ERROR.

    // se houver algum campo personalizado, busca as informacoes
    FIND FIRST ttPersonalization NO-LOCK NO-ERROR.
    IF  AVAILABLE ttPersonalization THEN DO:
        FOR EACH idioma NO-LOCK:
            oObj = NEW JsonObject().
            oObj:add("id", RECID(idioma)).

            // deve somente alimentar os campos que serao personalizados    
            hTab = BUFFER idioma:HANDLE.
            FOR EACH ttPersonalization:    
                ASSIGN cFld = ttPersonalization.cod_campo_perzdo.
                oObj:add(cFld, hTab:BUFFER-FIELD(cFld):buffer-value()) NO-ERROR.
            END.
            hTab:BUFFER-RELEASE().
            DELETE OBJECT hTab NO-ERROR.

            oList:add(oObj).
        END.
    END.

    oObj = NEW JSonObject().
    oObj:add("items", oList).

    LOG-MANAGER:WRITE-MESSAGE("pGetAll - oObj = " + String(oObj:getJsonText()), ">>>>>").
    
    oResponse   = NEW JsonAPIResponse(oObj).
    oJsonOutput = oResponse:createJsonResponse().
END PROCEDURE.

/** Procedure que cria um novo registro na tabela **/
PROCEDURE pCreate:
    DEFINE INPUT  PARAMETER oJsonInput  AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER oJsonOutput AS JsonObject NO-UNDO. 
    
    DEFINE VARIABLE cCodIdioma     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cDesIdioma     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cCodIdiomPadr  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE rIdioma        AS RECID     NO-UNDO.
    DEFINE VARIABLE lCreated       AS LOGICAL   NO-UNDO INITIAL FALSE.
 
    // Le os parametros e os dados enviados pela interface HTML
    oRequest = NEW JsonAPIRequestParser(oJsonInput).
    oBody    = oRequest:getPayload().

    rTab = ?.

    // Obtem o programa e o codigo do registro corrente
    cProg = oRequest:getPathParams():getCharacter(1) NO-ERROR.
    cId = oRequest:getPathParams():getCharacter(2) NO-ERROR.

    LOG-MANAGER:WRITE-MESSAGE("pCreate - cProg = " + cProg, ">>>>>").
    LOG-MANAGER:WRITE-MESSAGE("pCreate - cId = " + cId, ">>>>>").

    // retorna a lista de campos a serem personalizados
    EMPTY TEMP-TABLE ttPersonalization.
    RUN btb/personalizationUtil.p PERSISTENT SET hPers.
    RUN piGetTTPersonalization IN hPers (cProg, OUTPUT table ttPersonalization).
    DELETE PROCEDURE hPers NO-ERROR.

    // se houver algum campo personalizado, busca as informacoes
    FIND FIRST ttPersonalization NO-LOCK NO-ERROR.
    IF  AVAILABLE ttPersonalization THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
        CREATE idioma.
        
        // faz a gravacao dos dados onde os campos personalizados estao com o mesmo nome dos campos da tabela 
        hTab = BUFFER idioma:HANDLE.
        RUN piSetPersonalizationData (hTab, oBody).
        rTab = hTab:RECID.

        hTab:BUFFER-RELEASE() NO-ERROR.
        DELETE OBJECT hTab NO-ERROR.
    END.
    
    // Retorna o ID e se foi criado com sucesso
    oBody = NEW JsonObject().
    oBody:add('id', rTab).
    oBody:add('created', (IF lCreated THEN 'OK' ELSE 'NOK')).   

    // Retorna o oBody montado para a interface HTML
    oResponse   = NEW JsonAPIResponse(oBody).
    oJsonOutput = oResponse:createJsonResponse().
END PROCEDURE.

/** Procedure que atualiza o conteudo do registro pelo ID **/ 
PROCEDURE pUpdate:
    DEFINE INPUT  PARAMETER oJsonInput  AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER oJsonOutput AS JsonObject NO-UNDO.

    DEFINE VARIABLE lUpdated       AS LOGICAL    NO-UNDO INITIAL FALSE.

    DEFINE VARIABLE oIdioma        AS JsonObject NO-UNDO.
    DEFINE VARIABLE oId            AS JsonObject NO-UNDO.

    // Le os parametros e os dados enviados pela interface HTML
    oRequest = NEW JsonAPIRequestParser(oJsonInput).
    oBody    = oRequest:getPayload().
    oObj     = NEW JsonObject().
   
    cProg = oRequest:getPathParams():getCharacter(1) NO-ERROR.
    cId = oRequest:getPathParams():getCharacter(2) NO-ERROR.

    LOG-MANAGER:WRITE-MESSAGE("pUpdate - cProg = " + cProg, ">>>>>").
    LOG-MANAGER:WRITE-MESSAGE("pUpdate - cId = " + cId, ">>>>>").

    // retorna a lista de campos a serem personalizados
    EMPTY TEMP-TABLE ttPersonalization.
    RUN btb/personalizationUtil.p PERSISTENT SET hPers.
    RUN piGetTTPersonalization IN hPers (cProg, OUTPUT table ttPersonalization).
    DELETE PROCEDURE hPers NO-ERROR.

    // se houver algum campo personalizado, busca as informacoes
    FIND FIRST ttPersonalization NO-LOCK NO-ERROR.
    IF  AVAILABLE ttPersonalization THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
        FIND idioma
            WHERE RECID(idioma) = integer(cId) 
            EXCLUSIVE-LOCK NO-ERROR.
        IF  AVAILABLE idioma THEN DO:
            oObj:add("id", RECID(idioma)).
 
            // faz a gravacao dos dados onde os campos personalizados estao com o mesmo nome dos campos da tabela 
            hTab = BUFFER idioma:HANDLE.
            RUN piSetPersonalizationData (hTab, oBody).
            hTab:BUFFER-RELEASE() NO-ERROR.
            DELETE OBJECT hTab NO-ERROR.

            lUpdated = TRUE.
        END.
    END.

    // Retorna o ID e se foi atualizado com sucesso
    oBody = NEW JsonObject().
    oBody:add('id', cId).
    oBody:add('updated', (IF lUpdated THEN 'OK' ELSE 'NOK')).   

    // Retorna o oBody montado para a interface HTML
    oResponse   = NEW JsonAPIResponse(oBody).
    oJsonOutput = oResponse:createJsonResponse().
END PROCEDURE.

/** Procedure que atualiza o conteudo do registro pelo ID **/ 
PROCEDURE pDelete:
    DEFINE INPUT  PARAMETER oJsonInput  AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER oJsonOutput AS JsonObject NO-UNDO.

    DEFINE VARIABLE lDeleted AS LOGICAL NO-UNDO INITIAL FALSE.

    // Le os parametros enviados pela interface HTML
    oRequest = NEW JsonAPIRequestParser(oJsonInput).
    
    // Le os parametros e os dados enviados pela interface HTML
    oRequest = NEW JsonAPIRequestParser(oJsonInput).
    oBody    = oRequest:getPayload().
    oObj     = NEW JsonObject().
   
    cProg = oRequest:getPathParams():getCharacter(1) NO-ERROR.
    cId = oRequest:getPathParams():getCharacter(2) NO-ERROR.

    LOG-MANAGER:WRITE-MESSAGE("pDelete - cProg = " + cProg, ">>>>>").
    LOG-MANAGER:WRITE-MESSAGE("pDelete - cId = " + cId, ">>>>>").

    // retorna a lista de campos a serem personalizados
    EMPTY TEMP-TABLE ttPersonalization.
    RUN btb/personalizationUtil.p PERSISTENT SET hPers.
    RUN piGetTTPersonalization IN hPers (cProg, OUTPUT table ttPersonalization).
    DELETE PROCEDURE hPers NO-ERROR.

    // somente elimina o registro se houverem campos personalizaveis
    FIND FIRST ttPersonalization NO-LOCK NO-ERROR.
    IF  AVAILABLE ttPersonalization THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
        FIND idioma
            WHERE RECID(idioma) = integer(cId) 
            EXCLUSIVE-LOCK NO-ERROR.
        IF  AVAILABLE idioma THEN DO:
            DELETE idioma.

            ASSIGN lDeleted = TRUE.
        END.
    END.
    
    // Retorna o ID e se foi criado com sucesso
    oObj = NEW JsonObject().
    oObj:add('id', cId).
    oObj:add('deleted', (IF lDeleted THEN 'OK' ELSE 'NOK')).
    
    // Retorna o oBody montado para a interface HTML
    oResponse   = NEW JsonAPIResponse(oObj).
    oJsonOutput = oResponse:createJsonResponse().
END PROCEDURE.

PROCEDURE pValidateForm:
    DEFINE INPUT  PARAMETER oJsonInput  AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER oJsonOutput AS JsonObject NO-UNDO.

    DEFINE VARIABLE cProp      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE oValue     AS JsonObject           NO-UNDO.
    DEFINE VARIABLE cValue     AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE oNewValue  AS JsonObject           NO-UNDO.
    DEFINE VARIABLE oNewFields AS JsonArray            NO-UNDO.
    DEFINE VARIABLE cFocus     AS CHARACTER            NO-UNDO.

    DEFINE VARIABLE oRet       AS JsonObject           NO-UNDO.
    DEFINE VARIABLE oMessages  AS JsonArray            NO-UNDO.

    oRequest = NEW JsonAPIRequestParser(oJsonInput).
    oBody    = oRequest:getPayload().
   
    // obtem o nome da propriedade que ocorreu o LEAVE para validacao
    cProp      = oBody:getCharacter("property")     NO-ERROR.
    oValue     = oBody:getJsonObject("value")       NO-ERROR.
    cValue     = STRING(oValue:GetCharacter(cProp)) NO-ERROR.
    cId        = oValue:getCharacter("id")          NO-ERROR.
    
    /* Recebemos do HTML o JSON abaixo
    {
        "property": "codAcoes",
        "value": {
            "codIdiomPadr": "01 Portuguˆs",
            "codIdioma": "12345678",
            "desIdioma": "12345678901234567890",
            "id": 6,
        }
    }
    */

    // Novas Acoes sobre os campos da tela
    
    // oNewValue guarda os valores a serem especificados para os campos
    ASSIGN oNewValue = NEW JsonObject().
    
    // oNewFields guarda a lista de campos que serao alterados/modificados
    ASSIGN oNewFields = NEW JsonArray().
    
    // cFocus especifica em qual campo sera feito o focus
    ASSIGN cFocus = cProp.

    // oMessages guarda as mensagens de retorno formato 
    // { code: '00', message: 'texto', detailedMessage: 'detalhes da mensagem' }
    ASSIGN oMessages = NEW JsonArray().

    //
    // adicinar a logica de validacoes dos campos aqui
    //
   
    ASSIGN oRet = NEW JsonObject().
    // value -> contem todos os valores dos campos de tela
    oRet:add('value', oNewValue).
    // fields -> contem a lista de campos com suas novas propriedades
    oRet:add('fields', oNewFields).
    // focus -> especifica em qual campo o cursor vai ficar posicionado
    oRet:add('focus', cFocus).
    // _messages -> contem uma lista de mensagens que vao aparecer como notificacoes
    oRet:add('_messages', oMessages).
    
    oResponse   = NEW JsonAPIResponse(oRet).
    oJsonOutput = oResponse:createJsonResponse().
END PROCEDURE.

PROCEDURE piSetPersonalizationData:
    DEFINE INPUT PARAMETER hTab  AS HANDLE     NO-UNDO.
    DEFINE INPUT PARAMETER oBody AS JsonObject NO-UNDO. 

    FOR EACH ttPersonalization:
        ASSIGN cFld  = ttPersonalization.cod_campo_perzdo
               cType = JsonAPIUtils:convertAblTypeToHtmlType(ttPersonalization.des_tip_campo_perzdo).
        CASE cType:
            WHEN "string"   THEN
                hTab:BUFFER-FIELD(cFld):buffer-value() = oBody:getCharacter(cFld) NO-ERROR.
            WHEN "number"   THEN
                hTab:BUFFER-FIELD(cFld):buffer-value() = oBody:getInteger(cFld) NO-ERROR.
            WHEN "currency" THEN
                hTab:BUFFER-FIELD(cFld):buffer-value() = oBody:getDecimal(cFld) NO-ERROR.
            WHEN "boolean"  THEN
                hTab:BUFFER-FIELD(cFld):buffer-value() = oBody:getLogical(cFld) NO-ERROR.
            WHEN "datetime" THEN
                hTab:BUFFER-FIELD(cFld):buffer-value() = oBody:getDatetime(cFld) NO-ERROR.
            WHEN "date"     THEN
                hTab:BUFFER-FIELD(cFld):buffer-value() = oBody:getDate(cFld) NO-ERROR.
        END CASE.
    END.
END PROCEDURE.
    
/* fim */
