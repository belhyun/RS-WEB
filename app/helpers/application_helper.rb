module ApplicationHelper
  def fail(msg)
    {:code => 0, :msg => msg}
  end
end
