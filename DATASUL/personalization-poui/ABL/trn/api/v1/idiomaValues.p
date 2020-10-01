{utp/ut-api.i}

{utp/ut-api-action.i pGetData GET /~* }
{utp/ut-api-action.i pSaveData POST /save/~* }

{utp/ut-api-notfound.i}

/** Procedure que retorna os valores **/
PROCEDURE pGetData:
    DEFINE INPUT  PARAMETER oJsonInput  AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER oJsonOutput AS JsonObject NO-UNDO.

    DEFINE VARIABLE oRequest   AS JsonAPIRequestParser NO-UNDO.
    DEFINE VARIABLE oResponse  AS JsonAPIResponse      NO-UNDO.
    DEFINE VARIABLE oObj       AS JsonObject           NO-UNDO.
    DEFINE VARIABLE cProg      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cId        AS CHARACTER            NO-UNDO.

    oObj = NEW JsonObject().

    // Le os parametros enviados pela interface HTML
    oRequest = NEW JsonAPIRequestParser(oJsonInput).
    
    // Obtem o programa e o codigo do registro corrente
    cProg = oRequest:getPathParams():getCharacter(1) NO-ERROR.
    cId = oRequest:getPathParams():getCharacter(2) NO-ERROR.

    LOG-MANAGER:WRITE-MESSAGE("getData - cProg = " + cProg, ">>>>>").
    LOG-MANAGER:WRITE-MESSAGE("getData - cId = " + cId, ">>>>>").

    FIND FIRST prog_dtsul
        WHERE prog_dtsul.cod_prog_dtsul = cProg
        NO-LOCK NO-ERROR.
    LOG-MANAGER:WRITE-MESSAGE("getData - prog found = " + string(AVAILABLE prog_dtsul), ">>>>>").
    IF  AVAILABLE prog_dtsul THEN 
        LOG-MANAGER:WRITE-MESSAGE("getData - permite personalizacao = " + string(prog_dtsul.log_permite_perzdo), ">>>>>").
        
    IF  AVAILABLE prog_dtsul 
    AND prog_dtsul.log_permite_perzdo = TRUE THEN DO:
        FIND FIRST idioma 
            WHERE idioma.cod_idioma = cId
            NO-LOCK NO-ERROR.
        LOG-MANAGER:WRITE-MESSAGE("getData - idioma found = " + string(AVAILABLE idioma), ">>>>>").
        IF  AVAILABLE idioma THEN DO:
            oObj:add("codIdioma", idioma.cod_idioma).
            oObj:add("desIdioma", idioma.des_idioma).
            oObj:add("codIdiomPadr", idioma.cod_idiom_padr).
        END.
        LOG-MANAGER:WRITE-MESSAGE("getData - oObj = " + String(oObj:getJsonText()), ">>>>>").
    END.

    oResponse   = NEW JsonAPIResponse(oObj).
    oJsonOutput = oResponse:createJsonResponse().
END PROCEDURE.

/** Procedure que grava os valores no banco **/
PROCEDURE pSaveData:
    DEFINE INPUT  PARAMETER oJsonInput  AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER oJsonOutput AS JsonObject NO-UNDO.

    DEFINE VARIABLE oBody          AS JsonObject           NO-UNDO. 
    DEFINE VARIABLE oObj           AS JsonObject           NO-UNDO. 
    DEFINE VARIABLE oRequest       AS JsonAPIRequestParser NO-UNDO.
    DEFINE VARIABLE oResponse      AS JsonAPIResponse      NO-UNDO.

    DEFINE VARIABLE cProg          AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cId            AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cCodIdioma     AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cDesIdioma     AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cCodIdiomPadr  AS CHARACTER            NO-UNDO.
 
    // Le os parametros e os dados enviados pela interface HTML
    oRequest = NEW JsonAPIRequestParser(oJsonInput).
    oBody    = oRequest:getPayload().

    // Obtem o programa e o codigo do registro corrente
    cProg = oRequest:getPathParams():getCharacter(1) NO-ERROR.
    cId = oRequest:getPathParams():getCharacter(2) NO-ERROR.

    LOG-MANAGER:WRITE-MESSAGE("saveData - cProg = " + cProg, ">>>>>").
    LOG-MANAGER:WRITE-MESSAGE("saveData - cId = " + cId, ">>>>>").
    
    // Obtem os demais dados
    cCodIdioma    = oBody:getCharacter("codIdioma") NO-ERROR.
    cDesIdioma    = oBody:getCharacter("desIdioma") NO-ERROR.
    cCodIdiomPadr = oBody:getCharacter("codIdiomPadr") NO-ERROR.

    oObj = NEW JsonObject().

    FIND FIRST prog_dtsul
        WHERE prog_dtsul.cod_prog_dtsul = cProg
        NO-LOCK NO-ERROR.
        
    IF  AVAILABLE prog_dtsul 
    AND prog_dtsul.log_permite_perzdo = TRUE THEN DO:
        FIND FIRST idioma 
            WHERE idioma.cod_idioma = cId
            EXCLUSIVE-LOCK NO-ERROR.
        IF  NOT AVAILABLE idioma THEN DO:
            CREATE idioma.
            ASSIGN idioma.cod_idioma = cCodIdioma.
        END.
        ASSIGN idioma.des_idioma     = cDesIdioma 
               idioma.cod_idiom_padr = cCodIdiomPadr. 
    END.

    oResponse   = NEW JsonAPIResponse(oObj).
    oJsonOutput = oResponse:createJsonResponse().
END PROCEDURE.

/* fim */
