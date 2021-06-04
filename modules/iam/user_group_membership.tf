resource "aws_iam_user_group_membership" "marcostoledo" {
  user   = aws_iam_user.marcostoledo.name
  groups = [aws_iam_group.developers.id]
}

resource "aws_iam_user_group_membership" "nicolasfujisawa" {
  user = aws_iam_user.nicolasfujisawa.name
  groups = [aws_iam_group.developers.id]
}

resource "aws_iam_user_group_membership" "marcelofernandes" {
  user = aws_iam_user.marcelofernandes.name
  groups = [aws_iam_group.developers.id]
}

resource "aws_iam_user_group_membership" "leonardolopes" {
  user = aws_iam_user.leonardolopes.name
  groups = [aws_iam_group.developers.id]
}

resource "aws_iam_user_group_membership" "jasondavin" {
  user = aws_iam_user.jasondavin.name
  groups = [aws_iam_group.developers.id]
}

resource "aws_iam_user_group_membership" "bot_ci_cd" {
  user = aws_iam_user.bot_ci_cd.name
  groups = [aws_iam_group.developers.name]
}
