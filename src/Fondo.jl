import HTTPClient.HTTPC
import JSON

module Fondo

export getValue

function getvalue(node, id)
    response = HTTPC.get(node * "/value/" * id)
    result = JSON.parse(bytestring(response.body))
    result["uri"] = replace(result["uri"], " ", "+")
    result["data"] = bytestring(HTTPC.get(result["uri"]).body)
    result
end

function putvalue(node, id)
end

end
