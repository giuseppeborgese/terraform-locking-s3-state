resource "aws_security_group" "sg" {
  vpc_id      = "vpc-xxxxxx"
  name        = "Testlock"
}

variable "number" { default = 10 }
resource "aws_security_group_rule" "rule" {
  count             =  var.number
  type              = "ingress"
  protocol          = "tcp"
  from_port         = count.index
  to_port           = count.index
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
}
