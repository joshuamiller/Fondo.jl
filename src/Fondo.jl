import HTTPClient.HTTPC
import JSON
import SHA
using BEncode

module Fondo

export getvalue, putvalue

function getvalue(node, id)
    response = HTTPC.get(node * "/value/" * id)
    result = JSON.parse(bytestring(response.body))
    result["uri"] = replace(result["uri"], " ", "+")
    result["data"] = bytestring(HTTPC.get(result["uri"]).body)
    result
end

function hashval(val::Dict{Any,Any})
    val["data"] = bytestring(HTTPC.get(val["uri"]).body)
    id = SHA.sha384(bencode(val))
    delete!(val, "data")
    id
end

function putvalue(node, val::Dict{Any,Any})
    id = hashval(val)
    response = HTTPC.put(node * "/value/" * id,
                         JSON.json(val),
                         HTTPC.RequestOptions(headers=[("Content-Type", "application/json")]))
    JSON.parse(bytestring(response.body))
end

function putvalue(node, val::Dict{Any,Any}, filename)
end

end
