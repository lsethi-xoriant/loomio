class API::MotionsController < API::RestfulController
  include UsesDiscussionReaders
  load_and_authorize_resource only: [:show], find_by: :key

  def close
    load_resource
    @event = MotionService.close_by_user(@motion, current_user)
    respond_with_resource
  end

  def create_outcome
    load_and_authorize(:motion, :create_outcome)
    @event = MotionService.create_outcome(motion: @motion,
                                          params: permitted_params.motion,
                                          actor:  current_user)
    respond_with_resource
  end

  def update_outcome
    load_and_authorize(:motion, :update_outcome)
    @event = MotionService.update_outcome(motion: @motion,
                                          params: permitted_params.motion,
                                          actor:  current_user)
    respond_with_resource
  end

  private

  def visible_records
    load_and_authorize :discussion
    Queries::VisibleMotions.new(user: current_user, groups: current_user.groups)
                           .where(discussion: @discussion)
                           .order(:created_at)
  end

  def serializer_root
    :proposals
  end

end
