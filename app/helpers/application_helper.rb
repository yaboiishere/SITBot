module ApplicationHelper
    def self.authorize 
        oob_url = "urn:ietf:wg:oauth:2.0:oob".freeze
        application_name = "Elеktro prostotii".freeze
        file = File.open("token.yaml", "w")
        file.write "---\ndefault: "
        file.write(ENV["DOCS_AUTH_TOKEN"].to_json)
        file.close
        credentials_json = (JSON.parse(ENV["DOCS_CREDENTIALS"])).freeze
        token_path = "token.yaml".freeze
        scope = Google::Apis::DocsV1::AUTH_DOCUMENTS_READONLY
        client_id = Google::Auth::ClientId.from_hash credentials_json
        token_store = Google::Auth::Stores::FileTokenStore.new file: token_path
        authorizer = Google::Auth::UserAuthorizer.new client_id, scope, token_store
        user_id = "default"
        credentials = authorizer.get_credentials user_id
        if credentials.nil?
            url = authorizer.get_authorization_url base_url: oob_url
            puts "Open the following URL in the browser and enter the " \
                "resulting code after authorization:\n" + url
            code = gets
            credentials = authorizer.get_and_store_credentials_from_code(
                user_id: user_id, code: code, base_url: oob_url
            )
        end
        credentials
     end
end
