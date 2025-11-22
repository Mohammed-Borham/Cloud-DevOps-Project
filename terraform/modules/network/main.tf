resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "terraform-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "terraform-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "terraform-public-rt"
  }
}

resource "aws_subnet" "public" {
  count = length(var.azs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "terraform-public-subnet-${count.index}"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_network_acl" "public_nacl" {
  vpc_id    = aws_vpc.main.id
  subnet_ids = aws_subnet.public[*].id
}

resource "aws_network_acl_rule" "public_http_inbound" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  from_port      = 80
  to_port        = 80
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_https_inbound" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  from_port      = 443
  to_port        = 443
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_outbound" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 200
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_ephemeral_outbound" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 300
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "allow_ephemeral_inbound" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 1000
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}
