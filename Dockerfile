# Etapa de compilação
FROM golang:alpine AS builder

# Definir um diretório de trabalho
WORKDIR /app

# Copiar o arquivo go.mod e go.sum (se existir)
COPY go.mod .
COPY go.sum* ./

# Baixar dependências de módulos Go
# Isso é feito separadamente para aproveitar a cache do Docker
RUN go mod download

# Copiar os arquivos de código fonte Go para o container
COPY *.go .

# Compilar o código Go
# Desabilitar CGO e compilar o código Go para um binário estático
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o fullcycle .

# Etapa de execução
FROM scratch

# Copiar o binário estático do builder para a imagem scratch
COPY --from=builder /app/fullcycle .

# Executar o binário
CMD ["./fullcycle"]
