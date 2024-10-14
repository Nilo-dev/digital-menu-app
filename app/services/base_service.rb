class BaseService
  def self.data_present?(data)
    data.present?
  end

  def self.format_error_message(base_message, error)
    "#{base_message}: #{error.message}"
  end
end
