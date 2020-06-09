/**************************************************************************
** idiomas_upc.p - Exemplo de epc para Endpoints REST 
** 18/05/2020 - Menna - Criado exemplo
***************************************************************************/

USING PROGRESS.json.*.
USING PROGRESS.json.ObjectModel.*.
USING com.totvs.framework.api.*.

DEFINE INPUT        PARAMETER pEndPoint AS CHARACTER  NO-UNDO.
DEFINE INPUT        PARAMETER pEvent    AS CHARACTER  NO-UNDO.
DEFINE INPUT        PARAMETER pAPI      AS CHARACTER  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER jsonIO    AS JSONObject NO-UNDO.

DEFINE VARIABLE jAList  AS JsonArray  NO-UNDO.
DEFINE VARIABLE jObj    AS JsonObject NO-UNDO.

DEFINE VARIABLE ix      AS INTEGER    NO-UNDO.
DEFINE VARIABLE iTot    AS INTEGER    NO-UNDO.

DEFINE VARIABLE cCodIdioma  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCodUsuario AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNomUsuario AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCodDialet  AS CHARACTER  NO-UNDO.

/* ***************************  Main Block  *************************** */

// Carrega as definicoes dos campos customizados da tabela
IF  pEndPoint = "getMetaData"
AND pEvent    = "getMetaData" THEN DO ON STOP UNDO, LEAVE:

    // Obtem a lista de campos e valores    
    ASSIGN jAList = jsonIO:getJsonArray('root').

    // Cria os novos campos na lista
    ASSIGN jObj = NEW JsonObject().
    jObj:add('property', 'codUsuario').
    jObj:add('label', 'Usu rio').
    jObj:add('visible', TRUE).
    jObj:add('required', TRUE).
    jObj:add('type', JsonAPIUtils:convertAblTypeToHtmlType('character')).
    jObj:add('gridColumns', 6).
    jAList:add(jObj).
    
    ASSIGN jObj = NEW JsonObject().
    jObj:add('property', 'nomUsuario').
    jObj:add('label', 'Nome').
    jObj:add('visible', TRUE).
    jObj:add('required', TRUE).
    jObj:add('type', JsonAPIUtils:convertAblTypeToHtmlType('character')).
    jObj:add('gridColumns', 6).
    jAList:add(jObj).

    ASSIGN jObj = NEW JsonObject().
    jObj:add('property', 'codDialet').
    jObj:add('label', 'Dialeto').
    jObj:add('visible', TRUE).
    jObj:add('required', TRUE).
    jObj:add('type', JsonAPIUtils:convertAblTypeToHtmlType('character')).
    jObj:add('gridColumns', 6).
    jAList:add(jObj).
    
    // Retorna a nova lista com os campos customizados
    jsonIO:Set("root", jAList).
END.

// Carrega os valores dos campos customizados das tabelas
IF  pEndPoint = "findAll"
AND pEvent    = "findAll" THEN DO ON STOP UNDO, LEAVE:
    // Obtem a lista de campos e valores    
    ASSIGN jAList = jsonIO:getJsonArray('root').

    LOG-MANAGER:WRITE-MESSAGE("UPC FINDALL", ">>>>").

    FIND FIRST usuar_mestre NO-LOCK NO-ERROR.

    // Armazena o tamanho da lista em variavel para evitar LOOP devido a adicionar novos itens na lista
    ASSIGN iTot = jAList:length.

    DO  ix = 1 TO iTot:
        ASSIGN jObj = jAList:GetJsonObject(ix).
        
        // Alimenta os novos dados
        IF  AVAILABLE usuar_mestre THEN DO:
            jObj:add('codUsuario', usuar_mestre.cod_usuario) NO-ERROR.
            jObj:add('nomUsuario', usuar_mestre.nom_usuario) NO-ERROR.
            jObj:add('codDialet', usuar_mestre.cod_dialet) NO-ERROR.
        END.
        
        // Atualiza o objeto na lista
        jAList:set(ix, jObj).
        
        FIND NEXT usuar_mestre NO-LOCK NO-ERROR.
    END.

    // Retorna o json ROOT a lista nova com novos dados customizados 
    jsonIO:Set("root", jAList).
END.

IF  pEndPoint = "findById"
AND pEvent    = "findById" THEN DO ON STOP UNDO, LEAVE:
    // Obtem as informacoes necessarias da API para retornar dados    
    cCodIdioma  = jsonIO:getCharacter("codIdioma"). // chave estrangeira

    LOG-MANAGER:WRITE-MESSAGE("UPC FINDBYID cod_idioma= " + cCodIdioma, ">>>>").

    // Adiciona os valores da tabela customizada no retorno
    FIND FIRST usuar_mestre NO-LOCK NO-ERROR.
    IF  AVAILABLE usuar_mestre THEN DO:
        jsonIO:add('codUsuario', usuar_mestre.cod_usuario) NO-ERROR.
        jsonIO:add('nomUsuario', usuar_mestre.nom_usuario) NO-ERROR.
        jsonIO:add('codDialet', usuar_mestre.cod_dialet) NO-ERROR.
    END.
END.

IF  pEndPoint = "create"
AND pEvent    = "afterCreate" THEN DO ON STOP UNDO, LEAVE:
    // Obtem as informacoes necessarias da API para criacao do registro    
    cCodIdioma  = jsonIO:getCharacter("codIdioma") NO-ERROR. // chave estrangeira
    cCodUsuario = jsonIO:getCharacter("codUsuario") NO-ERROR.
    cNomUsuario = jsonIO:getCharacter("nomUsuario") NO-ERROR.
    cCodDialet  = jsonIO:getCharacter("codDialet") NO-ERROR.

    LOG-MANAGER:WRITE-MESSAGE("UPC CREATE cod_idioma= " + cCodIdioma, ">>>>").
    LOG-MANAGER:WRITE-MESSAGE("UPC CREATE cod_usuario= " + cCodUsuario, ">>>>").
    
    // logica de CREATE
    /* Em comentario a logica para nao criar registros desnecessariamente
    FIND FIRST usuar_mestre
        WHERE usuar_mestre.cod_usuario = cCodUsuario
        EXCLUSIVE-LOCK NO-ERROR.
    IF  NOT AVAILABLE usuar_mestre THEN DO:
        ASSIGN usuar_mestre.nom_usuario = cNomUsuario
               usuar_mestre.cod_dialet  = cCodDialet. 
    END.
    */
END.

IF  pEndPoint = "update"
AND pEvent    = "afterUpdate" THEN DO ON STOP UNDO, LEAVE:
    // Obtem as informacoes necessarias da API para atualizacao    
    cCodIdioma  = jsonIO:getCharacter("codIdioma") NO-ERROR. // chave estrangeira
    cCodUsuario = jsonIO:getCharacter("codUsuario") NO-ERROR.
    cNomUsuario = jsonIO:getCharacter("nomUsuario") NO-ERROR.
    cCodDialet  = jsonIO:getCharacter("codDialet") NO-ERROR.
    
    LOG-MANAGER:WRITE-MESSAGE("UPC UPDATE cod_idioma= " + cCodIdioma, ">>>>").
    LOG-MANAGER:WRITE-MESSAGE("UPC UPDATE cod_usuario= " + cCodUsuario, ">>>>").

    // logica de UPDATE
    /* Em comentario a logica para nao alterar tabelas desnecessariamente
    FIND FIRST usuar_mestre
        WHERE usuar_mestre.cod_usuario = cCodUsuario
        EXCLUSIVE-LOCK NO-ERROR.
    IF  AVAILABLE usuar_mestre THEN DO:
        ASSIGN usuar_mestre.nom_usuario = cNomUsuario
               usuar_mestre.cod_dialet  = cCodDialet. 
    END.
    */
END.

IF  pEndPoint = "delete"
AND pEvent    = "beforeDelete" THEN DO ON STOP UNDO, LEAVE:
    // obtem as informacoes necessarias da API para eliminacao    
    cCodIdioma  = jsonIO:getCharacter("codIdioma"). // chave estrangeira
    
    LOG-MANAGER:WRITE-MESSAGE("UPC DELETE cod_idioma= " + cCodIdioma, ">>>>").

    // logica de DELETE
    /* Em comentario a logica para nao eliminar o registro desnecessariamente
    FIND FIRST usuar_mestre
        WHERE usuar_mestre.cod_usuario = cCodUsuario
        EXCLUSIVE-LOCK NO-ERROR.
    IF  AVAILABLE usuar_mestre THEN DO:
        delete usuar_mestre.
    END.
    */
END.

RETURN "OK".

/* fim */
