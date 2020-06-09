{utp/ut-api.i}

{utp/ut-api-action.i pFindById GET /byid/~* }
{utp/ut-api-action.i pFindAll GET /~* }

{utp/ut-api-action.i pUpdateById PUT /~* }

{utp/ut-api-action.i pGetMetadata POST /metadata/~* }
{utp/ut-api-action.i pCreate POST /~* }

{utp/ut-api-action.i pDeleteById DELETE /~* }

{utp/ut-api-notfound.i}

DEFINE TEMP-TABLE ttIdiomas NO-UNDO
    FIELD cod_idioma      LIKE idioma.cod_idioma      SERIALIZE-NAME "codIdioma"
    FIELD des_idioma      LIKE idioma.des_idioma      SERIALIZE-NAME "desIdioma"
    FIELD cod_idiom_padr  LIKE idioma.cod_idiom_padr  SERIALIZE-NAME "codIdiomPadr"
    FIELD dat_ult_atualiz LIKE idioma.dat_ult_atualiz SERIALIZE-NAME "datUltAtualiz"
    FIELD hra_ult_atualiz LIKE idioma.hra_ult_atualiz SERIALIZE-NAME "hraUltAtualiz"
    FIELD id              AS RECID.

/** Procedure que retorna a metadata **/
PROCEDURE pGetMetadata:
    DEFINE INPUT  PARAMETER oJsonInput  AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER oJsonOutput AS JsonObject NO-UNDO.

    DEFINE VARIABLE oResponse AS JsonAPIResponse NO-UNDO.
    DEFINE VARIABLE oIdiomas  AS JsonArray       NO-UNDO.
    DEFINE VARIABLE oObj      AS JsonObject      NO-UNDO.

    ASSIGN oIdiomas = NEW JsonArray().
    
    /* Define a lista de campos a serem apresentados no HTML */
    ASSIGN oObj = NEW JsonObject().
    oObj:add('property', 'codIdioma').
    oObj:add('label', 'Idioma').
    oObj:add('visible', TRUE).
    oObj:add('disable', TRUE).
    oObj:add('type', JsonAPIUtils:convertAblTypeToHtmlType('character')).
    oObj:add('gridColumns', 6).
    oIdiomas:add(oObj).
    
    ASSIGN oObj = NEW JsonObject().
    oObj:add('property', 'desIdioma').
    oObj:add('label', 'Descri‡Æo').
    oObj:add('visible', TRUE).
    oObj:add('required', TRUE).
    oObj:add('type', JsonAPIUtils:convertAblTypeToHtmlType('character')).
    oObj:add('gridColumns', 6).
    oIdiomas:add(oObj).

    ASSIGN oObj = NEW JsonObject().
    oObj:add('property', 'codIdiomPadr').
    oObj:add('label', 'Idioma PadrÆo').
    oObj:add('visible', TRUE).
    oObj:add('type', JsonAPIUtils:convertAblTypeToHtmlType('character')).
    oObj:add('gridColumns', 6).
    oIdiomas:add(oObj).

    ASSIGN oObj = NEW JsonObject().
    oObj:add('property', 'datUltAtualiz').
    oObj:add('label', 'éltima Atualiza‡Æo').
    oObj:add('visible', TRUE).
    oObj:add('format', 'dd/MM/yyyy').
    oObj:add('disable', TRUE).
    oObj:add('type', JsonAPIUtils:convertAblTypeToHtmlType('date')).
    oObj:add('gridColumns', 6).
    oIdiomas:add(oObj).

    ASSIGN oObj = NEW JsonObject().
    oObj:add('property', 'hraUltAtualiz').
    oObj:add('label', 'Hora éltima Atualiza‡Æo').
    oObj:add('visible', TRUE).
    oObj:add('disable', TRUE).
    oObj:add('type', JsonAPIUtils:convertAblTypeToHtmlType('character')).
    oObj:add('gridColumns', 6).
    oIdiomas:add(oObj).
    
    // Adiciona o campo ID na lista de campos para a interface HTML
    // Isso facilitara o gerenciamento do registro na interface HTML
    oIdiomas:add(JsonAPIUtils:getIdField()).

    // Adiciona o JsonArray em um JsonObject para enviar para a UPC
    oObj        = NEW JsonObject().
    oObj:add('root', oIdiomas).
    
    // Realiza a chamada da UPC Progress
    {include/i-epcrest.i &endpoint=getMetaData &event=getMetaData &jsonVar=oObj}    

    // Recupera o JsonArray de dentro do JsonObject retornado pela UPC
    oIdiomas = oObj:getJsonArray('root').    
    
    // Retorna a colecao de campos customizados ou nao para a interface HTML
    oResponse   = NEW JsonAPIResponse(oIdiomas).
    oJsonOutput = oResponse:createJsonResponse().
END PROCEDURE.

/** Procedure que retorna os valores **/
PROCEDURE pFindAll:
    DEFINE INPUT  PARAMETER oJsonInput  AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER oJsonOutput AS JsonObject NO-UNDO.

    DEFINE VARIABLE oResponse AS JsonAPIResponse NO-UNDO.
    DEFINE VARIABLE oIdiomas  AS JsonArray       NO-UNDO.
    DEFINE VARIABLE oObj      AS JsonObject      NO-UNDO.
    DEFINE VARIABLE oId       AS JsonObject      NO-UNDO.
 
    EMPTY TEMP-TABLE ttIdiomas.

    // Monta a lista de valores dos campos
    FOR EACH idioma NO-LOCK BY idioma.cod_idioma:
        CREATE ttIdiomas.
        BUFFER-COPY idioma TO ttIdiomas.
        // Alimenta o campo ID utilizado pela interface HTML como chave primaria
        ASSIGN ttIdiomas.id = RECID(idioma).
    END.
    
    // Obtem um jsonArray com base no conteudo da temp-table
    oIdiomas    = JsonAPIUtils:convertTempTableToJsonArray(TEMP-TABLE ttIdiomas:HANDLE).

    // Adiciona o JsonArray em um JsonObject para enviar para a UPC
    oObj        = NEW JsonObject().
    oObj:add('root', oIdiomas).
    
    // Realiza a chamada da UPC Progress
    {include/i-epcrest.i &endpoint=findAll &event=findAll &jsonVar=oObj}

    // Recupera o JsonArray de dentro do JsonObject retornado pela UPC
    oIdiomas = oObj:getJsonArray('root').    

    // Retorna a colecao de dados customizados ou nao para a interface HTML
    oResponse   = NEW JsonAPIResponse(oIdiomas).
    oJsonOutput = oResponse:createJsonResponse().
END PROCEDURE.

/** Procedure que retorna 1 registro pelo ID **/ 
PROCEDURE pFindById:
    DEFINE INPUT  PARAMETER oJsonInput  AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER oJsonOutput AS JsonObject NO-UNDO.

    DEFINE VARIABLE oRequest   AS JsonAPIRequestParser NO-UNDO.
    DEFINE VARIABLE oResponse  AS JsonAPIResponse      NO-UNDO.
    DEFINE VARIABLE oIdioma    AS JsonObject           NO-UNDO.
    DEFINE VARIABLE oId        AS JsonObject           NO-UNDO.
    
    DEFINE VARIABLE cId        AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE iId        AS INTEGER              NO-UNDO.

    EMPTY TEMP-TABLE ttIdiomas.

    // Le os parametros enviados pela interface HTML
    oRequest = NEW JsonAPIRequestParser(oJsonInput).
    
    // Obtem o ID
    cId = oRequest:getPathParams():getCharacter(2).
    
    // Localiza o registro na tabela IDIOMA pelo ID (recid)
    FIND FIRST idioma 
        WHERE RECID(idioma) = INT(cId)
        NO-LOCK NO-ERROR.
    IF AVAILABLE idioma THEN DO:
        BUFFER-COPY idioma TO ttIdiomas.
        ASSIGN ttIdiomas.id = RECID(idioma).
    END.
    
    // Obtem um jsonArray com base no conteudo da temp-table
    oIdioma     = JsonAPIUtils:convertTempTableFirstItemToJsonObject(TEMP-TABLE ttIdiomas:HANDLE).

    // Realiza a chamada da UPC Progress
    {include/i-epcrest.i &endpoint=findById &event=findById &jsonVar=oIdioma}    
   
    // Retorna o registro customizado ou nao para a interface HTML
    oResponse   = NEW JsonAPIResponse(oIdioma).
    oJsonOutput = oResponse:createJsonResponse().
END PROCEDURE.

/** Procedure que cria um novo registro na tabela **/
PROCEDURE pCreate:
    DEFINE INPUT  PARAMETER oJsonInput  AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER oJsonOutput AS JsonObject NO-UNDO. 

    DEFINE VARIABLE oBody          AS JsonObject           NO-UNDO. 
    DEFINE VARIABLE oRequest       AS JsonAPIRequestParser NO-UNDO.
    DEFINE VARIABLE oResponse      AS JsonAPIResponse      NO-UNDO.
    
    DEFINE VARIABLE cCodIdioma     AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cDesIdioma     AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cCodIdiomPadr  AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE rIdioma        AS RECID                NO-UNDO.
    DEFINE VARIABLE lCreated       AS LOGICAL              NO-UNDO INITIAL FALSE.
 
    // Le os parametros e os dados enviados pela interface HTML
    oRequest = NEW JsonAPIRequestParser(oJsonInput).
    oBody    = oRequest:getPayload().
    
    // Obtem os demais dados
    cCodIdioma    = oBody:getCharacter("codIdioma") NO-ERROR.
    cDesIdioma    = oBody:getCharacter("desIdioma") NO-ERROR.
    cCodIdiomPadr = oBody:getCharacter("codIdiomPadr") NO-ERROR.

    // Cria o registro na tabela IDIOMA
    DO  TRANSACTION
        ON ERROR UNDO, LEAVE:
        FIND FIRST idioma
            WHERE idioma.cod_idioma = cCodIdioma
            NO-LOCK NO-ERROR.
        IF  NOT AVAILABLE idioma THEN DO:
            CREATE idioma.
            ASSIGN idioma.cod_idioma      = cCodIdioma
                   idioma.des_idioma      = cDesIdioma
                   idioma.cod_idiom_padr  = cCodIdiomPadr
                   idioma.dat_ult_atualiz = TODAY
                   idioma.hra_ult_atualiz = STRING(TIME,"HH:MM:SS")
                   rIdioma                = RECID(idioma)
                   lCreated               = TRUE.
        
            // Realiza a chamada da UPC Progress para a criacao do 
            // registro customizado. Nao utilizaremos o retorno da UPC
            // neste caso. 
            {include/i-epcrest.i &endpoint=create &event=afterCreate &jsonVar=oBody}    
        
            RELEASE idioma.
        END.
    END.

    // Retorna o ID e se foi criado com sucesso
    oBody = NEW JsonObject().
    oBody:add('id', rIdioma).
    oBody:add('created', (IF lCreated THEN 'OK' ELSE 'NOK')).   

    // Retorna o oBody montado para a interface HTML
    oResponse   = NEW JsonAPIResponse(oBody).
    oJsonOutput = oResponse:createJsonResponse().
END PROCEDURE.

/** Procedure que atualiza o conteudo do registro pelo ID **/ 
PROCEDURE pUpdateById:
    DEFINE INPUT  PARAMETER oJsonInput  AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER oJsonOutput AS JsonObject NO-UNDO.

    DEFINE VARIABLE oBody          AS JsonObject           NO-UNDO. 
    DEFINE VARIABLE oRequest       AS JsonAPIRequestParser NO-UNDO.
    DEFINE VARIABLE oResponse      AS JsonAPIResponse      NO-UNDO.
    DEFINE VARIABLE oIdioma        AS JsonObject           NO-UNDO.
    DEFINE VARIABLE oId            AS JsonObject           NO-UNDO.
    DEFINE VARIABLE cId            AS CHARACTER            NO-UNDO.
    
    DEFINE VARIABLE cCodIdioma     AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cDesIdioma     AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cCodIdiomPadr  AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE datUltAtualiz  AS DATE                 NO-UNDO.
    DEFINE VARIABLE hraUltAtualiz  AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE lUpdated       AS LOGICAL              NO-UNDO INITIAL FALSE.

    // Le os parametros e os dados enviados pela interface HTML
    oRequest = NEW JsonAPIRequestParser(oJsonInput).
    oBody    = oRequest:getPayload().
   
    // Obtem o ID
    cId      = oRequest:getPathParams():getCharacter(1).

    // Obtem os demais dados
    cCodIdioma    = oBody:getCharacter("codIdioma") NO-ERROR.
    cDesIdioma    = oBody:getCharacter("desIdioma") NO-ERROR.
    cCodIdiomPadr = oBody:getCharacter("codIdiomPadr") NO-ERROR.
    
    // Atualiza o registro na tabela IDIOMA pelo ID (recid)
    DO  TRANSACTION
        ON ERROR UNDO, LEAVE:
        FIND FIRST idioma 
            WHERE RECID(idioma) = INT(cId)
            EXCLUSIVE-LOCK NO-ERROR.
        IF  AVAILABLE idioma THEN DO:
            ASSIGN idioma.des_idioma      = cDesIdioma
                   idioma.cod_idiom_padr  = cCodIdiomPadr
                   idioma.dat_ult_atualiz = TODAY
                   idioma.hra_ult_atualiz = STRING(TIME,"HH:MM:SS")
                   lUpdated               = TRUE.
            
            // Realiza a chamada da UPC Progress para atualizar o registro
            // na tabela cutomizada ou nao. Nao utilizaremos o retorno da UPC
            // neste caso. 
            {include/i-epcrest.i &endpoint=update &event=afterUpdate &jsonVar=oBody}    
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
PROCEDURE pDeleteById:
    DEFINE INPUT  PARAMETER oJsonInput  AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER oJsonOutput AS JsonObject NO-UNDO.

    DEFINE VARIABLE oObj           AS JsonObject           NO-UNDO.
    DEFINE VARIABLE oRequest       AS JsonAPIRequestParser NO-UNDO.
    DEFINE VARIABLE oResponse      AS JsonAPIResponse      NO-UNDO.
    DEFINE VARIABLE oArray         AS JsonArray            NO-UNDO.
    DEFINE VARIABLE oIdioma        AS JsonObject           NO-UNDO.
    DEFINE VARIABLE oId            AS JsonObject           NO-UNDO.
    DEFINE VARIABLE cId            AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE lDeleted       AS LOGICAL              NO-UNDO INITIAL FALSE.
    DEFINE VARIABLE ix             AS INTEGER              NO-UNDO.

    // Le os parametros enviados pela interface HTML
    oRequest = NEW JsonAPIRequestParser(oJsonInput).
    
    // Eliminacao de registro individual
    IF  oRequest:getPathParams():length > 0 THEN DO:
        // Obtem o ID
        cId = oRequest:getPathParams():getCharacter(1).
        
        RUN piDeleteRecord (cId).
        ASSIGN lDeleted = (RETURN-VALUE = "OK").
    END.
    ELSE DO:
        // Eliminacao de registros em lote
        // Obtem a lista de IDs diretamente do oJsonInput onde vem um JsonArray
        // oArray = oJsonInput:getJsonArray('payload').
        oArray = oRequest:getPayloadArray().
        DO  ix = 1 TO oArray:length:
            oObj = oArray:getJsonObject(ix).
            cId = STRING(oObj:getInteger('id')).
        
            RUN piDeleteRecord (cId).
            IF  lDeleted = FALSE THEN 
                ASSIGN lDeleted = (RETURN-VALUE = "OK").
        END.
    END.
    
    // Retorna o ID e se foi criado com sucesso
    oObj = NEW JsonObject().
    IF  oRequest:getPathParams():length > 0 THEN DO:
        oObj:add('id', cId).
    END.
    oObj:add('deleted', (IF lDeleted THEN 'OK' ELSE 'NOK')).
    
    // Retorna o oBody montado para a interface HTML
    oResponse   = NEW JsonAPIResponse(oObj).
    oJsonOutput = oResponse:createJsonResponse().
END PROCEDURE.

PROCEDURE piDeleteRecord:
    DEFINE INPUT PARAMETER cId AS CHARACTER NO-UNDO.

    DEFINE VARIABLE oObj           AS JsonObject           NO-UNDO.
    DEFINE VARIABLE lDeleted       AS LOGICAL NO-UNDO INITIAL FALSE.

    LOG-MANAGER:WRITE-MESSAGE("Eliminando registro -> " + cId, ">>>>>").

    // Elimina o registro na tabela IDIOMA pelo ID (recid)
    DO  TRANSACTION
        ON ERROR UNDO, LEAVE:
        FIND FIRST idioma 
            WHERE RECID(idioma) = INT(cId)
            EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE idioma THEN DO:
            // Monta a chave estrangeira para enviar para UPC
            // poder elominar o registro da tabela customizada
            oObj = NEW JsonObject().
            oObj:add('codIdioma', idioma.cod_idioma).
            
            // Realiza a chamada da UPC Progress para a eliminacao do 
            // registro customizado. Nao utilizaremos o retorno da UPC
            // neste caso. 
            {include/i-epcrest.i &endpoint=delete &event=beforeDelete &jsonVar=oObj}    

            DELETE idioma.
           
            ASSIGN lDeleted = TRUE.
        END.
    END.
    
    RETURN (IF lDeleted THEN "OK" ELSE "NOK").
END PROCEDURE.

/* fim */
