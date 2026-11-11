/* ========================================
   1. MENU RESPONSIVO
======================================== */
const botaoMenu = document.querySelector('.menu-toggle');
const menuPrincipal = document.querySelector('#menu-principal');

// Fecha o menu e restaura o botão.
function fecharMenu() {
    if (!botaoMenu || !menuPrincipal) return;

    menuPrincipal.classList.remove('aberto');
    botaoMenu.setAttribute('aria-expanded', 'false');
    botaoMenu.setAttribute('aria-label', 'Abrir menu');
    botaoMenu.textContent = '☰';
}

if (botaoMenu && menuPrincipal) {

    // Abre ou fecha o menu ao clicar no botão.
    botaoMenu.addEventListener('click', () => {
        const estaAberto = menuPrincipal.classList.toggle('aberto');

        botaoMenu.setAttribute('aria-expanded', String(estaAberto));
        botaoMenu.setAttribute('aria-label', estaAberto ? 'Fechar menu' : 'Abrir menu');
        botaoMenu.textContent = estaAberto ? '✕' : '☰';
    });

    // Fecha o menu quando um link é selecionado.
    menuPrincipal.querySelectorAll('a').forEach((link) => {
        link.addEventListener('click', fecharMenu);
    });

    // Fecha o menu com Escape e devolve o foco ao botão.
    document.addEventListener('keydown', (evento) => {
        if (evento.key === 'Escape' && menuPrincipal.classList.contains('aberto')) {
            fecharMenu();
            botaoMenu.focus();
        }
    });

    // Fecha o menu ao voltar para a tela desktop.
    window.matchMedia('(min-width: 1101px)').addEventListener('change', (evento) => {
        if (evento.matches) {
            fecharMenu();
        }
    });

    // Fecha o menu ao clicar fora dele.
    document.addEventListener('click', (evento) => {
        const clicouNoMenu = menuPrincipal.contains(evento.target);
        const clicouNoBotao = botaoMenu.contains(evento.target);

        if (!clicouNoMenu && !clicouNoBotao) {
            fecharMenu();
        }
    });
}


/* ========================================
   2. MODO CLARO E ESCURO
======================================== */

const botaoTema = document.querySelector('#tema-toggle');
const elementoHTML = document.documentElement;

// Aplica o estado visual do botão com base no tema atual.
function atualizarEstadoBotao(tema) {
    const temaClaro = tema === 'light';

    botaoTema.textContent = temaClaro ? '☾' : '☀';
    botaoTema.setAttribute('aria-pressed', String(temaClaro));

    // Atualiza a cor da barra do navegador no celular.
    const metaTema = document.querySelector('meta[name="theme-color"]');

    if (metaTema) {
        metaTema.setAttribute('content', temaClaro ? '#f5f0e8' : '#0d0b0e');
    }
}

if (botaoTema) {

    // Garante que o tema seja sempre 'light' ou 'dark'.
    const temaInicial = elementoHTML.dataset.theme === 'light' ? 'light' : 'dark';
    elementoHTML.dataset.theme = temaInicial;
    atualizarEstadoBotao(temaInicial);

    // Alterna entre claro e escuro.
    botaoTema.addEventListener('click', () => {
        const novoTema = elementoHTML.dataset.theme === 'dark' ? 'light' : 'dark';

        elementoHTML.dataset.theme = novoTema;
        atualizarEstadoBotao(novoTema);

        // Guarda a escolha para a próxima visita.
        try {
            localStorage.setItem('tema', novoTema);
        } catch (erro) {
            // A troca de tema continua funcionando sem armazenamento.
        }
    });
}


/* ========================================
   3. ABAS DE CÓDIGO
======================================== */

document.querySelectorAll('[data-abas]').forEach((grupo) => {
    const abas = Array.from(grupo.querySelectorAll('[role="tab"]'));
    const paineis = Array.from(grupo.querySelectorAll('[role="tabpanel"]'));

    // Mostra a aba escolhida e esconde as outras.
    function selecionar(indice, moverFoco) {
        abas.forEach((aba, i) => {
            const ativa = i === indice;

            aba.setAttribute('aria-selected', String(ativa));
            aba.setAttribute('tabindex', ativa ? '0' : '-1');
            paineis[i].hidden = !ativa;
        });

        if (moverFoco) {
            abas[indice].focus();
        }
    }

    abas.forEach((aba, indice) => {
        aba.addEventListener('click', () => selecionar(indice, false));

        // Setas, Home e End navegam entre as abas.
        aba.addEventListener('keydown', (evento) => {
            let novoIndice = null;

            if (evento.key === 'ArrowRight') {
                novoIndice = (indice + 1) % abas.length;
            } else if (evento.key === 'ArrowLeft') {
                novoIndice = (indice - 1 + abas.length) % abas.length;
            } else if (evento.key === 'Home') {
                novoIndice = 0;
            } else if (evento.key === 'End') {
                novoIndice = abas.length - 1;
            }

            if (novoIndice !== null) {
                evento.preventDefault();
                selecionar(novoIndice, true);
            }
        });
    });
});


/* ========================================
   4. CARROSSEL DE SPRITES
======================================== */

document.querySelectorAll('[data-carrossel]').forEach((carrossel) => {
    const faixa = carrossel.querySelector('.carrossel-faixa');
    const slides = Array.from(carrossel.querySelectorAll('.carrossel-slide'));
    const botaoAnterior = carrossel.querySelector('[data-anterior]');
    const botaoProximo = carrossel.querySelector('[data-proximo]');
    const areaPontos = carrossel.querySelector('[data-pontos]');

    let atual = 0;

    // Cria um ponto para cada slide.
    const pontos = slides.map((slide, indice) => {
        const ponto = document.createElement('button');

        ponto.type = 'button';
        ponto.className = 'ponto';
        ponto.setAttribute('aria-label', 'Ir para a imagem ' + (indice + 1));
        ponto.addEventListener('click', () => ir(indice));

        areaPontos.appendChild(ponto);
        return ponto;
    });

    // Vai para o slide indicado (volta ao início depois do último).
    function ir(indice) {
        atual = (indice + slides.length) % slides.length;

        faixa.style.transform = 'translateX(-' + (atual * 100) + '%)';

        slides.forEach((slide, i) => {
            slide.setAttribute('aria-hidden', String(i !== atual));
        });

        pontos.forEach((ponto, i) => {
            ponto.setAttribute('aria-current', String(i === atual));
        });
    }

    botaoAnterior.addEventListener('click', () => ir(atual - 1));
    botaoProximo.addEventListener('click', () => ir(atual + 1));

    // Setas do teclado quando o carrossel está em foco.
    carrossel.addEventListener('keydown', (evento) => {
        if (evento.key === 'ArrowLeft') {
            ir(atual - 1);
        } else if (evento.key === 'ArrowRight') {
            ir(atual + 1);
        }
    });

    // Se a imagem ainda não existe, mostra um rótulo no lugar.
    carrossel.querySelectorAll('.carrossel-imagem img').forEach((imagem) => {
        const caixa = imagem.closest('.carrossel-imagem');
        const marcar = () => caixa.classList.add('sem-imagem');

        if (imagem.complete && imagem.naturalWidth === 0) {
            marcar();
        }

        imagem.addEventListener('error', marcar);
    });

    ir(0);
});