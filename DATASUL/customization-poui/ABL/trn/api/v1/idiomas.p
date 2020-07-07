{utp/ut-api.i}

{utp/ut-api-action.i pFindById GET /byid/~* }
{utp/ut-api-action.i pFindAll GET /~* }

{utp/ut-api-action.i pUpdateById PUT /~* }

{utp/ut-api-action.i pGetMetadata POST /metadata/~* }
{utp/ut-api-action.i pValidateForm POST /validateForm/~* }
{utp/ut-api-action.i pValidateField POST /validateField/~* }
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
    DEFINE VARIABLE oOpts     AS JsonArray       NO-UNDO.
    DEFINE VARIABLE oObj      AS JsonObject      NO-UNDO.
    DEFINE VARIABLE oOpt      AS JsonObject      NO-UNDO.

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

    // acoes de tela para testes de validacao do formulario
    ASSIGN oOpts = NEW JsonArray().
    ASSIGN oOpt = NEW JsonObject().
    oOpt:add('label', 'Foco CodIdiomaPadrao').
    oOpt:add('value', 'focoCodIdiomPadr').
    oOpts:add(oOpt).
    ASSIGN oOpt = NEW JsonObject().
    oOpt:add('label', 'Foco DesIdioma').
    oOpt:add('value', 'FocoDesIdioma').
    oOpts:add(oOpt).
    ASSIGN oOpt = NEW JsonObject().
    oOpt:add('label', 'Desabilita CodIdiomaPadrao').
    oOpt:add('value', 'DesabilitaCodIdiomaPadrao').
    oOpts:add(oOpt).
    ASSIGN oOpt = NEW JsonObject().
    oOpt:add('label', 'Habilita CodIdiomaPadrao').
    oOpt:add('value', 'HabilitaCodIdiomaPadrao').
    oOpts:add(oOpt).
    ASSIGN oOpt = NEW JsonObject().
    oOpt:add('label', 'Mascara CPF').
    oOpt:add('value', 'MascaraCPF').
    oOpts:add(oOpt).
    ASSIGN oOpt = NEW JsonObject().
    oOpt:add('label', 'Mascara CNPJ').
    oOpt:add('value', 'MascaraCNPJ').
    oOpts:add(oOpt).
    ASSIGN oOpt = NEW JsonObject().
    oOpt:add('label', 'TrocaValor DesIdioma').
    oOpt:add('value', 'TrocaValorDesIdioma').
    oOpts:add(oOpt).
    ASSIGN oOpt = NEW JsonObject().
    oOpt:add('label', 'Esconder DesIdioma').
    oOpt:add('value', 'EsconderDesIdioma').
    oOpts:add(oOpt).
    ASSIGN oOpt = NEW JsonObject().
    oOpt:add('label', 'Aparecer DesIdioma').
    oOpt:add('value', 'AparecerDesIdioma').
    oOpts:add(oOpt).
    ASSIGN oOpt = NEW JsonObject().
    oOpt:add('label', 'Mostra Mensagem de Erro').
    oOpt:add('value', 'showErrorMessage').
    oOpts:add(oOpt).
    ASSIGN oOpt = NEW JsonObject().
    oOpt:add('label', 'Muda Label DesIdioma').
    oOpt:add('value', 'mudaLabelDesIdioma').
    oOpts:add(oOpt).

    ASSIGN oObj = NEW JsonObject().
    oObj:add('property', 'codAcoes').
    oObj:add('label', 'Acoes de Tela').
    oObj:add('visible', TRUE).
    oObj:add('type', JsonAPIUtils:convertAblTypeToHtmlType('character')).
    oObj:add('options', oOpts).
    oObj:add('gridColumns', 12).
    oObj:add('validate', '/api/trn/v1/idiomas/validateField').
    oIdiomas:add(oObj).

    // Informacoes de Tipo de Pessoa
    ASSIGN oOpts = NEW JsonArray().
    ASSIGN oOpt = NEW JsonObject().
    oOpt:add('label', 'Pessoa Fisica').
    oOpt:add('value', 'f').
    oOpts:add(oOpt).
    ASSIGN oOpt = NEW JsonObject().
    oOpt:add('label', 'Pessoa Juridica').
    oOpt:add('value', 'j').
    oOpts:add(oOpt).
    
    ASSIGN oObj = NEW JsonObject().
    oObj:add('property', 'tipUsuario').
    oObj:add('label', 'Tipo do usuario').
    oObj:add('visible', TRUE).
    oObj:add('type', JsonAPIUtils:convertAblTypeToHtmlType('character')).
    oObj:add('options', oOpts).
    oObj:add('gridColumns', 6).
    oObj:add('validate', '/api/trn/v1/idiomas/validateField').    
    oIdiomas:add(oObj).

    ASSIGN oObj = NEW JsonObject().
    oObj:add('property', 'codCpfCnpj').
    oObj:add('label', 'CPF/CNPJ').
    oObj:add('visible', TRUE).
    oObj:add('mask', '999.999.999-99').
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

PROCEDURE pValidateForm:
    DEFINE INPUT  PARAMETER oJsonInput  AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER oJsonOutput AS JsonObject NO-UNDO.

    DEFINE VARIABLE oRequest   AS JsonAPIRequestParser NO-UNDO.
    DEFINE VARIABLE oResponse  AS JsonAPIResponse      NO-UNDO.
    DEFINE VARIABLE oBody      AS JsonObject           NO-UNDO.
    DEFINE VARIABLE cProp      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE oValue     AS JsonObject           NO-UNDO.
    DEFINE VARIABLE cValue     AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cId        AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE oNewValue  AS JsonObject           NO-UNDO.
    DEFINE VARIABLE oNewFields AS JsonArray            NO-UNDO.
    DEFINE VARIABLE cFocus     AS CHARACTER            NO-UNDO.

    DEFINE VARIABLE oRet       AS JsonObject           NO-UNDO.
    DEFINE VARIABLE oObj       AS JsonObject           NO-UNDO.
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
            "hraUltAtualiz": "",
            "datUltAtualiz": null,
            "id": 6,
            "codAcoes": "FocoDesIdioma"
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
   
    CASE cProp:
        WHEN "codAcoes" THEN DO:
            CASE cValue:
                WHEN 'focoCodIdiomPadr' THEN DO:
                    // setamos o focus para o campo desejado
                    ASSIGN cFocus = 'codIdiomPadr'.
                END.
                WHEN 'FocoDesIdioma' THEN DO:
                    // setamos o focus para o campo desejado
                    ASSIGN cFocus = 'desIdioma'.
                END.
                WHEN 'DesabilitaCodIdiomaPadrao' THEN DO:
                    // criamos um novo field para desabilitar
                    ASSIGN oObj = NEW JsonObject().
                    oObj:add('property', 'codIdiomPadr').
                    oObj:add('disabled', TRUE).
                    oNewFields:add(oObj).
                END.
                WHEN 'HabilitaCodIdiomaPadrao' THEN DO:
                    // criamos um novo field para habilitar
                    ASSIGN oObj = NEW JsonObject().
                    oObj:add('property', 'codIdiomPadr').
                    oObj:add('disabled', FALSE).
                    oNewFields:add(oObj).
                END.
                WHEN 'MascaraCPF' THEN DO:
                    // IMPORTANTE:
                    // Quando alteramos o valor do radio-set tipUsuario por aqui,
                    // O value-changed dele que especifica qual a mascara
                    // ser  utilizada NAO sera disparado, pois ele ‚ dinamico e 
                    // estamos validando o campo codAcoes, sendo necessario 
                    // fazermos a formatacao da mascara aqui tambem. 
                    // A mesma regra ‚ valida para o CNPJ
                    
                    // mudamos os valores dos campos desejados
                    oNewValue:add('tipUsuario', 'f').
                    oNewValue:add('codCpfCnpj', FILL('0',11)).

                    // criamos um novo field para mudar a mascara
                    ASSIGN oObj = NEW JsonObject().
                    oObj:add('property', 'codCpfCnpj').
                    oObj:add('mask', '999.999.999-99').
                    oNewFields:add(oObj).
                END.
                WHEN 'MascaraCNPJ' THEN DO:
                    // IMPORTANTE:
                    // Quando alteramos o valor do radio-set tipUsuario por aqui,
                    // O value-changed dele que especifica qual a mascara
                    // ser  utilizada NAO sera disparado, pois ele ‚ dinamico e 
                    // estamos validando o campo codAcoes, sendo necessario 
                    // fazermos a formatacao da mascara aqui tambem. 
                    // A mesma regra ‚ valida para o CPF

                    // alteramos os valores dos campos desejados
                    oNewValue:add('tipUsuario', 'j').
                    oNewValue:add('codCpfCnpj', FILL('0',15)).

                    // criamos um novo field para mudar a mascara
                    ASSIGN oObj = NEW JsonObject().
                    oObj:add('property', 'codCpfCnpj').
                    oObj:add('mask', '99.999.999/9999-99').
                    oNewFields:add(oObj).
                END.
                WHEN 'TrocaValorDesIdioma' THEN DO:
                    // alteramos o conteudo de um campo qualquer
                    oNewValue:add('desIdioma', "Valor retornado do backend de validacao").
                END.
                WHEN 'EsconderDesIdioma' THEN DO:
                    // criamos um novo field para tornar invisivel o campo
                    ASSIGN oObj = NEW JsonObject().
                    oObj:add('property', 'desIdioma').
                    oObj:add('visible', FALSE).
                    oNewFields:add(oObj).
                END.
                WHEN 'AparecerDesIdioma' THEN DO:
                    // criamos um novo field para tornar visivel o campo
                    ASSIGN oObj = NEW JsonObject().
                    oObj:add('property', 'desIdioma').
                    oObj:add('visible', TRUE).
                    oNewFields:add(oObj).
                END.
                WHEN 'mudaLabelDesIdioma' THEN DO:
                    // criamos um novo field para mudar o label
                    ASSIGN oObj = NEW JsonObject().
                    oObj:add('property', 'desIdioma').
                    oObj:add('label', 'Label alterado da descricao').
                    oNewFields:add(oObj).
                END.
                WHEN 'showErrorMessage' THEN DO:
                    // criamos uma mensagem de erro
                    ASSIGN oObj = NEW JsonObject().
                    oObj:add('code', '33').
                    oObj:add('message', 'A Descricao do idioma nao foi preenchida corretamente'). 
                    oObj:add('detailedMessage', 'Detalhe da mensagem de erro').
                    oMessages:add(oObj).
                END.
            END CASE.
        END.
        WHEN "tipUsuario" THEN DO:
            // setamos o focus para o campo desejado
            ASSIGN cFocus = 'codCpfCnpj'.

            // criamos um field para mudar o informar o campo e a nova mascara
            ASSIGN oObj = NEW JsonObject().
            oObj:add('property', "codCpfCnpj").
            IF  cValue = "j" THEN DO:
                // ‚ definido um novo valor para o CNPJ
                oNewValue:add('codCpfCnpj', FILL('0',15)).
                // ‚ alterado o formato da mascara de edicao
                oObj:add('mask', '99.999.999/9999-99').
            END.
            IF  cValue = "f" THEN DO:
                // ‚ definido um novo valor para o CPF
                oNewValue:add('codCpfCnpj', FILL('0',11)).
                // ‚ alterado o formato da mascara de edicao
                oObj:add('mask', '999.999.999-99').
            END.
            oNewFields:add(oObj).
        END.
    END CASE.
    
    ASSIGN oRet = NEW JsonObject().
    // value -> contem todos os valores dos campos de tela
    oRet:add('value', oNewValue).
    // fields -> contem a lista de campos com suas novas propriedades
    oRet:add('fields', oNewFields).
    // focus -> especifica em qual campo o cursor vai ficar posicionado
    oRet:add('focus', cFocus).
    // _messages -> contem uma lista de mensagens que vao aparecer como notificacoes
    oRet:add('_messages', oMessages).
    
    // encapsulamos o retorno para enviar para a UPC
    oObj = NEW JsonObject().
    oObj:add("property", cProp).
    oObj:add("originalValues", oValue).
    oObj:add("root", oRet).

    // Realiza a chamada da UPC Progress
    {include/i-epcrest.i &endpoint=validateForm &event=validateForm &jsonVar=oObj}    

    // obtem o retorno customizado, onde o mesmo foi alterado e retornado na tag root 
    oRet = oObj:getJsonObject("root").

    /* JSON de retorno para o HTML      
    value: {
      desIdioma: 'teste de escrita',
      hraUltAtualiz: '17:18:19'
    },
    fields: [
      {
        property: 'codCpfCnpj', 
        mask: '99.999.999/9999-99' 
      }
    ],
    focus: 'hraUltAtualiz',
    _messages: [ 
        { 
            code: '01', 
            message: 'Mensagem do erro que aconteceu', 
            detailedMessage: 'detalhes do erro acontecido' 
        } 
    ]
    */
    
    // Retorna a colecao de campos customizados ou nao para a interface HTML
    oResponse   = NEW JsonAPIResponse(oRet).
    oJsonOutput = oResponse:createJsonResponse().
END PROCEDURE.

PROCEDURE pValidateField:
    DEFINE INPUT  PARAMETER oJsonInput  AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER oJsonOutput AS JsonObject NO-UNDO.

    DEFINE VARIABLE oRequest   AS JsonAPIRequestParser NO-UNDO.
    DEFINE VARIABLE oResponse  AS JsonAPIResponse      NO-UNDO.
    DEFINE VARIABLE oBody      AS JsonObject           NO-UNDO.
    DEFINE VARIABLE cProp      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE oValue     AS JsonObject           NO-UNDO.
    DEFINE VARIABLE cValue     AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cId        AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE oNewValue  AS JsonObject           NO-UNDO.
    DEFINE VARIABLE oNewField  AS JsonObject           NO-UNDO.
    DEFINE VARIABLE lFocus     AS LOGICAL              NO-UNDO INITIAL FALSE.

    DEFINE VARIABLE oRet       AS JsonObject           NO-UNDO.
    DEFINE VARIABLE oObj       AS JsonObject           NO-UNDO.
    DEFINE VARIABLE oMessages  AS JsonArray            NO-UNDO.

    oRequest = NEW JsonAPIRequestParser(oJsonInput).
    oBody    = oRequest:getPayload().
   
    // obtem o nome da propriedade que ocorreu o LEAVE para validacao
    cProp      = oBody:getCharacter("property")     NO-ERROR.
    cValue     = oBody:getCharacter("value")        NO-ERROR.
    
    /* Recebemos do HTML o JSON abaixo
    {
        "property": "codAcoes",
        "value": "FocoDesIdioma"
    }
    */

    // Novas Acoes sobre os campos da tela
    
    // oNewField guarda o objeto que sera alterado/modificado
    ASSIGN oNewField = NEW JsonObject().
    
    // oMessages guarda as mensagens de retorno formato 
    // { code: '00', message: 'texto', detailedMessage: 'detalhes da mensagem' }
    ASSIGN oMessages = NEW JsonArray().

    IF  cProp = "tipUsuario" THEN DO:
        ASSIGN lFocus = TRUE.
        
        oNewField:add('property', "codCpfCnpj").
        IF  cValue = "j" THEN DO:
            // ‚ alterado o formato da mascara de edicao
            oNewField:add('mask', '99.999.999/9999-99').
        END.
        IF  cValue = "f" THEN DO:
            // ‚ alterado o formato da mascara de edicao
            oNewField:add('mask', '999.999.999-99').
        END.

        ASSIGN oObj = NEW JsonObject().
        oObj:add('code', '33').
        oObj:add('message', 'A mascara do CPF/CNPJ foi ajustada'). 
        oObj:add('detailedMessage', 'Ocorreu um ajusta na mascara do CPF/CNPJ, favor verificar se os dados estao corretos').
        oMessages:add(oObj).
    END.
    
    ASSIGN oRet = NEW JsonObject().
    // value -> contem todos os valores dos campos de tela
    oRet:add('value', cValue).
    // field -> contem os novos atributos do campo atual
    oRet:add('field', oNewField).
    // focus -> especifica se o campo recebe o focu
    oRet:add('focus', lFocus).
    // _messages -> contem uma lista de mensagens que vao aparecer como notificacoes
    oRet:add('_messages', oMessages).
    
    // encapsulamos o retorno para enviar para a UPC
    oObj = NEW JsonObject().
    oObj:add("property", cProp).
    oObj:add("root", oRet).

    // Realiza a chamada da UPC Progress
    {include/i-epcrest.i &endpoint=validateField &event=validateField &jsonVar=oObj}    

    // obtem o retorno customizado, onde o mesmo foi alterado e retornado somente 
    // o conteudo da tag return
    oRet = oObj:getJsonObject("root").

    /* JSON de retorno para o HTML      
    value: 'teste de escrita',
    field: {
        mask: '99.999.999/9999-99',
        required: true 
    },
    focus: true,
    _messages: [
        {
            code: '01', 
            message: 'Mensagem do erro que aconteceu', 
            detailedMessage: 'detalhes do erro acontecido' 
        }
    ]
    */
    
    // Retorna a colecao de campos customizados ou nao para a interface HTML
    oResponse   = NEW JsonAPIResponse(oRet).
    oJsonOutput = oResponse:createJsonResponse().
END PROCEDURE.

/* fim */
