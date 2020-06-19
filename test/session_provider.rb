class SessionProvider
  def self.with_session(session_hash)
    klass = ApplicationController
    old_session = klass.instance_method(:session)
    klass.define_method(:session, proc { session_hash })
    yield
  ensure
    klass.define_method(:session, old_session)
  end
end
