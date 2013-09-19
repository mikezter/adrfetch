require 'gmail'

class CollectSenders

  include Enumerable

  def initialize(user, pass, source_label, dest_label, limit = 1)
    @source_label, @dest_label, @limit = source_label, dest_label, limit
    @gmail = Gmail.connect(user, pass)
    @addresses = []
  end

  def mailbox
    @gmail.mailbox(@source_label)
  end

  def emails
    if @limit.nil?
      mailbox.emails
    else
      mailbox.emails.take(@limit)
    end
  end

  def each
    emails.each{ |m| yield process(m) }
  end

  def process(email)
    @addresses << construct_address(email.from.first)
    require 'pry';binding.pry
  end

  def construct_address(from)
    "#{from.mailbox}@#{from.host}"
  end

end

