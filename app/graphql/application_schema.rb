class ApplicationSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

  def self.context(ctx)
    ctx.merge(current_user: ctx[:env]['current_user'])
  end
end
