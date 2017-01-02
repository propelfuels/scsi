require 'json'
require 'time'

module SCSI

  module Helper

    def slash_keys
      return [
        :user_name, :user_id,
        :channel_name, :channel_id,
        :team_domain, :team_id
      ]
    end

    def parse_slash(params)
      return nil unless params.class == Hash
      info = {}
      slash_keys.each { |k| info[k] = params[k] }
      return info
    end

    def format_info(info)
      attachments = []
      i = 0
      while i < slash_keys.count do
        a = slash_keys[i]
        b = slash_keys[i + 1]
        attachments << {fields: [
          {title: a, value: info[a], short: true},
          {title: b, value: info[b], short: true}
        ]}
        i += 2
      end
      return {
        response_type: "ephemeral",
        text: "SCSI: Slash Command Slack Info v#{SCSI::Version}",
        attachments: attachments
      }
    end

    # Convert object into JSON, optionally pretty-format
    # @param obj [Object] any Ruby object
    # @param opts [Hash] any JSON options
    # @return [String] JSON string
    def json_with_object(obj, pretty: true, opts: nil)
      return '{}' if obj.nil?
      if pretty
        opts = {
          indent: '  ',
          space: ' ',
          object_nl: "\n",
          array_nl: "\n"
        }
      end
      JSON.fast_generate(json_format_value(obj), opts)
    end

    # Return Ruby object/value to JSON standard format
    # @param val [Object]
    # @return [Object]
    def json_format_value(val)
      case val
      when Array
        val.map { |v| json_format_value(v) }
      when Hash
        val.reduce({}) { |h, (k, v)| h.merge({k => json_format_value(v)}) }
      when String
        val.encode!('UTF-8', {invalid: :replace, undef: :replace})
      when Time
        val.utc.iso8601
      else
        val
      end
    end

  end

end
