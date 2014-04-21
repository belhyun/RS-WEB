class Route < ActiveRecord::Base
  belongs_to :region
  has_many :stations, :dependent => :destroy
  has_many :boards
  self.per_page = 10

  def self.get_boards(id, page)
    result = Hash.new
    route = Route.find(:first, :conditions => ['id = ?', id], :include => [:boards, :stations])
    result[:board_count] = route.boards_count
    result[:route] = route
    result[:region] = route.region
    result[:boards] = route.boards.paginate(:per_page => Route.per_page, :page => page).order(:created_at => :desc)
    .as_json(include: [{user: {include: :token} }, :attachments])
    result
  end
end
