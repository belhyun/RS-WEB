module ApplicationHelper
  def fail(msg)
    {:code => 0, :msg => msg}
  end

  def success()
    {:code => 1, :msg => 'success'}
end
