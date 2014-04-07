module ApplicationHelper
  def fail(msg)
    {:code => 0, :msg => msg}
  end

  def success(body)
    {:code => 1, :body => body, :msg => 'success'}
  end
end
