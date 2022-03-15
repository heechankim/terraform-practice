resource "aws_vpc" "main" {
	cidr_block = "10.0.0.0/16"
	
	tags = {
		Name = "terraform-practice"
	}
}

resource "aws_subnet" "public_subnet" {
	vpc_id = aws_vpc.main.id
	cidr_block = "10.0.0.0/24"

	availability_zone = "ap-northeast-2a"

	tags = {
		Name = "terraform-practice-public-subnet"
	}
}

resource "aws_subnet" "private_subnet" {
	vpc_id = aws_vpc.main.id
	cidr_block = "10.0.1.0/24"

	tags = {
		Name = "terraform-practice-private-subnet"
	}
}

resource "aws_internet_gateway" "igw" {
	vpc_id = aws_vpc.main.id
	
	tags = {
		Name = "terraform-practice-igw"
	}
}

resource "aws_eip" "nat" {
	vpc = true

	lifecycle {
		create_before_destroy = true
	}
}

resource "aws_nat_gateway" "nat_gateway" {
	allocation_id = aws_eip.nat.id

	subnet_id = aws_subnet.public_subnet.id
	
	tags = {
		Name = "terraform-natgw"
	}
}

resource "aws_route_table" "public" {
	vpc_id = aws_vpc.main.id

	tags = {
		Name = "terraform-rt-public"
	}
}

resource "aws_route_table_association" "route_table_association_public" {
	subnet_id = aws_subnet.public_subnet.id
	route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
	vpc_id = aws_vpc.main.id

	tags = {
		Name = "terraform-rt-private"
	}
}

resource "aws_route_table_association" "route_table_association_private" {
	subnet_id = aws_subnet.private_subnet.id
	route_table_id = aws_route_table.private.id
}
