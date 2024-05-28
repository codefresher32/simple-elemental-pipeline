resource "aws_cloudwatch_event_rule" "mediaconvert_event_rule" {
  name        = "${var.region}-${var.environment}-${var.prefix}-mediaconvert_event_rule"
  description = "Sends MediaConvert events to playout lambda"

  event_pattern = templatefile("${path.module}/mediaconvert_event_rules.json",
    {
      region      = var.region
      environment = var.environment
    }
  )
}

resource "aws_cloudwatch_event_target" "mediaconvert_event_target" {
  rule = aws_cloudwatch_event_rule.mediaconvert_event_rule.name
  arn  = aws_lambda_function.lambda_playout.arn
}

resource "aws_lambda_permission" "mediaconvert_event_invoke_playout_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_playout.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.mediaconvert_event_rule.arn
}
