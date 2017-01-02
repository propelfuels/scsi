require 'sinatra/base'
require 'scsi/helper'

module SCSI

  # The Sinatra server
  class Server < Sinatra::Base

    helpers Helper

    configure do
      set :environment, :production
      disable :static
      c = Config.shared
      set :dump_errors, c.dump_errors
      set :logging, c.logging
      SCSI.logger.info('Sinatra server configured.')
    end

    before do
      tokens = Config.shared.tokens
      halt 401 unless tokens.empty? || tokens.include?(params[:token])
    end

    post '/' do
      SCSI.logger.info('Incoming request received.')
      SCSI.logger.debug("Body size: #{request.content_length} bytes")
      info = parse_slash(params)
      json_with_object(format_info(info))
    end

    not_found do
      SCSI.logger.info('Invalid request.')
      SCSI.logger.debug("Request method and path: #{request.request_method} #{request.path}")
      json_with_object({message: 'Huh, nothing here.'})
    end

    error 401 do
      SCSI.logger.info(params[:token] ? 'Invalid token provided.' : 'Missing token.')
      SCSI.logger.debug("Provided auth token: #{params[:auth]}") if params[:auth]
      json_with_object({message: 'Oops, need a valid auth.'})
    end

    error do
      status 500
      err = env['sinatra.error']
      SCSI.logger.error "#{err.class.name} - #{err}"
      json_with_object({message: 'Yikes, internal error.'})
    end

    after do
      content_type 'application/json'
    end

  end
end
