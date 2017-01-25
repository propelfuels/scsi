require 'json'
require 'time'

module SCSI

  module Helper

    def slash_keys
      return [
        :user_id, :user_name,
        :channel_id, :channel_name,
        :team_id, :team_domain
      ]
    end

    def parse_slash(params)
      return nil unless params.class == Hash
      info = {}
      slash_keys.each { |k| info[k] = params[k] }
      info[:text] = params[:text]
      return info
    end

    def create_attachments(data:, keys:)
      attachments = []
      i = 0
      while i < keys.count do
        a = keys[i]
        b = keys[i + 1]
        attachments << {fields: [
          {title: a, value: data[a], short: true},
          {title: b, value: data[b], short: true}
        ]}
        i += 2
      end
      return attachments
    end

    def attachments_from_text(text)
      attachments = []
      text.scan(/<(.*?)>/) do |m|
        case m[0][0]
        when '#'
          keys = [:channel_id, :channel_name]
        when '@'
          keys = [:user_id, :user_name]
        when '!'
          keys = [:special_command, :label]
        else
          keys = [:link, :label]
        end
        values = m[0].split('|')
        data = {keys[0] => values[0][1..-1], keys[1] => values[1]}
        attachments << create_attachments(data: data, keys: keys)[0]
      end
      return attachments
    end

    def format_info(info)
      attachments = []
      q = ''
      attachments = attachments_from_text(info[:text]) if info[:text]
      if attachments.empty?
        attachments = create_attachments(data: info, keys: slash_keys)
      else
        q = " ?>> `#{info[:text]}`"
      end
      return {
        response_type: "ephemeral",
        text: "SCSI: Slash Command Slack Info v#{SCSI::Version}" + q,
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
